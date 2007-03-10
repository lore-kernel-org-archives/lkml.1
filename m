Return-Path: <linux-kernel-owner+w=401wt.eu-S933460AbXCJPDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460AbXCJPDX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 10:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933461AbXCJPDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 10:03:23 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:55288 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933460AbXCJPDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 10:03:22 -0500
Date: Sat, 10 Mar 2007 16:03:24 +0100
From: Adrian Bunk <bunk@stusta.de>
To: "Marcin 'Qrczak' Kowalczyk" <qrczak@knm.org.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: _proxy_pda still makes linking modules fail
Message-ID: <20070310150323.GN3441@stusta.de>
References: <1173315479.12472.9.camel@qrnik>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1173315479.12472.9.camel@qrnik>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 01:57:59AM +0100, Marcin 'Qrczak' Kowalczyk wrote:
> This is linux-2.6.20.1 with lots of patches from PLD Linux (I believe
> the patches don't affect the issue), compiled with gcc-4.1.2 and
> binutils-2.17.50.0.12 on x86.
>...

Please test a plain 2.6.20 from ftp.kernel.org.
If it fails, please send your .config .

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

