Return-Path: <linux-kernel-owner+w=401wt.eu-S1758372AbXJ3XGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372AbXJ3XGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbXJ3XGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:06:23 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:41491 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756825AbXJ3XGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:06:22 -0400
Date: Tue, 30 Oct 2007 23:59:17 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Ciaran McCreesh <ciaran.mccreesh@blueyonder.co.uk>
Cc: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Edward Hsu <edward_hsu@realtek.com.tw>
Subject: Re: Abit F-190HD Onboard rlt8169 Ethernet Controller
Message-ID: <20071030225917.GA11411@electric-eye.fr.zoreil.com>
References: <20071029061532.5d10dfc6@snowcone> <20071029083333.18a4dab7@the-village.bc.nu> <47259CFB.2090106@garzik.org> <20071029120007.GA8571@electric-eye.fr.zoreil.com> <20071030002727.279fb508@snowcone>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030002727.279fb508@snowcone>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ciaran McCreesh <ciaran.mccreesh@blueyonder.co.uk> :
> On Mon, 29 Oct 2007 13:00:07 +0100
> Francois Romieu <romieu@fr.zoreil.com> wrote:
> > Jeff Garzik <jeff@garzik.org> :
> > [...]
> > > Regardless, I agree with your "you...have a return candidate"
> > > comment.
> > 
> > I would welcome a complete lspci -vxx + dmesg before the board is
> > eventually returned though.
> 
> Attached.

Let aside the strange vendor ID, your 8168b is able to work with
2.6.24-rc1 when others see their 8168b temporarily disappear (no
trace in lspci at all). Can you send your (compressed) .config ?

Is there a different OS on this host ?

-- 
Ueimor
