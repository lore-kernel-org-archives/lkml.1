Return-Path: <linux-kernel-owner+w=401wt.eu-S1764234AbXHVPGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764234AbXHVPGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 11:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762828AbXHVPFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 11:05:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39634 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761087AbXHVPF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 11:05:29 -0400
Date: Wed, 22 Aug 2007 10:05:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, linux-security-module@vger.kernel.org,
       LKML Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
Message-ID: <20070822080533.GA2482@elf.ucw.cz>
References: <20070821073710.GB7258@elf.ucw.cz> <497654.62822.qm@web36611.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497654.62822.qm@web36611.mail.mud.yahoo.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > but you written it in wrong language. You
> > written it in C, while you should have written it in SELinux policy
> > language (and your favourite scripting language as frontend).
> 
> I have often marvelled at the notion of a simplification layer.
> I believe that you build complex things on top of simple things,
> not the other way around.

As we have to maintain selinux, anyway, I don't see why simplification
layer is a problem.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
