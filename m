Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbZDDSBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbZDDSBR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 14:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbZDDSA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 14:00:58 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:32417 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbZDDSA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 14:00:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=I/vrQNdKX4QtGHcJ9VXdhwn7Y/Ym0Op3WIQgEJyFiUTxdq8ZfAHOHBsV3nr8ZCOC0w
         Rb6Kf6G0DZ5wX7Qg/4iO19xj0vZAsuyVb9kkMg3c3ORdS8XtXx2A7JvN2XAjAIEDSOiK
         hCzYduh3DYVTEHA91CTiGW7AnydOZ8aisPRKA=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0904041039230.3915@localhost.localdomain>
References: <1238742067-30814-1-git-send-email-tytso@mit.edu>
	 <alpine.LFD.2.00.0904031110420.19690@localhost.localdomain>
	 <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain>
	 <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain>
	 <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk>
	 <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain>
	 <20090404173412.GF5178@kernel.dk>
	 <alpine.LFD.2.00.0904041039230.3915@localhost.localdomain>
Date: Sat, 4 Apr 2009 12:00:56 -0600
Message-ID: <9b1675090904041100s4620e604nfa8281e9ab869841@mail.gmail.com>
Subject: Re: [GIT PULL] Ext3 latency fixes
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Theodore Tso <tytso@mit.edu>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guys,

Sorry for this "quick" interruption.  Jens doesn't like the sqllite
problem.  Ted and Linus don't like the latency problem.  Why not make
that SYNC_ALL option a 1/0 option in /proc/sys/vm/sync_all or
something of the like?  That sort of change is pretty small, and quick
to make, right?  This would help, at least until the real problem is
found.

Sorry if I'm stepping out of bounds. :P
