Return-Path: <linux-kernel-owner+w=401wt.eu-S934523AbZJIVyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934523AbZJIVyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934513AbZJIVyE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:54:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:55460 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933079AbZJIVyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:54:02 -0400
Date: Fri, 9 Oct 2009 23:53:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
       Andreas Dilger <adilger@sun.com>
Subject: Re: ext4 corruptions
In-Reply-To: <1255116014.3014.8.camel@mini>
Message-ID: <alpine.LRH.2.00.0910092351140.12171@twin.jikos.cz>
References: <1255116014.3014.8.camel@mini>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ adding some CCs so that this doesn't get lost in the lkml wilderness ]

On Fri, 9 Oct 2009, Alexey Fisher wrote:

> I have really bad ext4 corruptions, i needed to reinstall 3 of my test
> systems.
> The symptoms:
> is use karmic beta for this with ubuntu supplied kernel 2.6.31 ... after
> testing 2.6.32-rc[1-3] and booting again to 2.6.31 fsck will find some
> bad things and will try to fix it. After this action is the system
> unusable.

Does this happen also when you switch from vanilla 2.6.32-rcX to vanilla 
2.6.31, or only from vanilla 2.6.32-rcX to "Ubuntu 2.6.31"?

> Do any one had same problem? The is no sans to bisect it, after some
> jumps between 2.6.31 and 2.6.32 the system will be broken.  Is it kernel
> or fsck problem?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

