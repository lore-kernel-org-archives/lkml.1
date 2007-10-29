Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768AbXJ2MHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbXJ2MHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 08:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbXJ2MGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 08:06:54 -0400
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:47528 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752101AbXJ2MGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 08:06:53 -0400
Date: Mon, 29 Oct 2007 13:00:07 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ciaran McCreesh <ciaran.mccreesh@blueyonder.co.uk>,
       linux-kernel@vger.kernel.org, Edward Hsu <edward_hsu@realtek.com.tw>
Subject: Re: Abit F-190HD Onboard rlt8169 Ethernet Controller
Message-ID: <20071029120007.GA8571@electric-eye.fr.zoreil.com>
References: <20071029061532.5d10dfc6@snowcone> <20071029083333.18a4dab7@the-village.bc.nu> <47259CFB.2090106@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47259CFB.2090106@garzik.org>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> :
[...]
> Regardless, I agree with your "you...have a return candidate" comment.

I would welcome a complete lspci -vxx + dmesg before the board is eventually
returned though.

(Ciaran: CFG_2 is needed, yes.)

-- 
Ueimor
