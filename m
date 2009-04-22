Return-Path: <linux-kernel-owner+w=401wt.eu-S1755670AbZDVIKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbZDVIKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 04:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbZDVIJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 04:09:51 -0400
Received: from mailbox-us-s-12.mailhostingserver.com ([75.125.101.9]:58130
	"EHLO mailbox-us-s-12.mailhostingserver.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753874AbZDVIJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 04:09:49 -0400
Date: Wed, 22 Apr 2009 10:09:44 +0200
From: Matthias Kaehlcke <matthias@kaehlcke.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.30-rc2 to -rc1 regression on arm
Message-ID: <20090422080944.GA20105@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias@kaehlcke.net>,
	Pavel Machek <pavel@ucw.cz>,
	linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
	kernel list <linux-kernel@vger.kernel.org>
References: <20090422075817.GA10992@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422075817.GA10992@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi pavel,

El Wed, Apr 22, 2009 at 09:58:17AM +0200 Pavel Machek ha dit:

> ...it now fails to compile in arch/arm/kernel/sys_oabi-compat.c ,
> complaining about missing prototypes for kmalloc/kfree.

AFAIK this is fixed in 2.6.30-rc3

see also http://lkml.org/lkml/2009/4/15/105

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

        They that can give up essential liberty to obtain a little
           temporary safety deserve neither liberty nor safety
                         (Benjamin Franklin)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
