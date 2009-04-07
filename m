Return-Path: <linux-kernel-owner+w=401wt.eu-S1758631AbZDGEOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631AbZDGEOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 00:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbZDGEN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 00:13:59 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:1780 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096AbZDGEN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 00:13:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PbjF9z9jGd2ph02wl1bLafQMFvVE6+/ajRtIKMB984YPwOgdCOEfKAJMlVYmrecWEK
         AHbdRMRF3QL0Jwz2REHJjYdDdXuMNGuPhFeDX3yz9kuSPkx8rtEeVYcFkd8qUS6RiwKO
         12aC0GCyqqW/HhlBOu/l78Mh8iO+N1dOgB4fM=
MIME-Version: 1.0
In-Reply-To: <1239076379.17426.23.camel@think.oraclecorp.com>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com>
	 <alpine.LFD.2.00.0904060803141.4023@localhost.localdomain>
	 <20090406151054.GD5178@kernel.dk>
	 <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain>
	 <20090406183157.GD7376@mit.edu>
	 <alpine.LFD.2.00.0904061255160.4134@localhost.localdomain>
	 <002501c9b6f3$f85b4910$e911db30$@com> <20090406211931.GB8586@mit.edu>
	 <1239076379.17426.23.camel@think.oraclecorp.com>
Date: Mon, 6 Apr 2009 22:13:56 -0600
Message-ID: <9b1675090904062113r2bd2b209hea1061cc54a0b9c0@mail.gmail.com>
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Theodore Tso <tytso@mit.edu>, Hua Zhong <hzhong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, so a config option is a benefit in what way, for these
particular circumstances?  If someone wants to change the behaviour of
the kernel, for this particular case, they can just use tune2fs, no?

I'm glad I'm not making the decision.  To break one person's computer
or another person's computer, hmm, not very good options. hehe.
