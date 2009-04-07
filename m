Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbZDGLZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbZDGLZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 07:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbZDGLY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 07:24:58 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:47060 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZDGLY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 07:24:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=N7IYR6rgZtEpXzVsGcWKBTOhcPAVFjks7n2ew+WBFBpfOxQvcWO57oxb7YuC3A5MGJ
         J6V3BSX3/Vt3oFxCmfuo51bj093ne+Cv4muqwKtTnAmJXOT0wnWsGaEqIkc4K9x+oPHs
         yARiec09YXkTxz16Lxp73IPWB5dqM7vaxTX/o=
Date: Tue, 7 Apr 2009 13:24:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jeff Mahoney <jeffm@suse.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>,
       Bron Gondwana <brong@fastmail.fm>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] reiserfs: kill-the-BKL
Message-ID: <20090407112450.GA5922@nowhere>
References: <1239070789-13354-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239070789-13354-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: I forgot to put the RFC prefix for this patch.

Frederic Weisbecker.

