Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbYHPKDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbYHPKDt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 06:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbYHPKDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 06:03:41 -0400
Received: from smtp.ono.com ([62.42.230.12]:2837 "EHLO resmaa01.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752154AbYHPKDk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 06:03:40 -0400
Date: Sat, 16 Aug 2008 12:03:14 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ath5k on the Acer Aspire One
Message-ID: <20080816120314.07d0bf57@werewolf.home>
In-Reply-To: <20080815015131.39bb20ef@werewolf.home>
References: <20080815015131.39bb20ef@werewolf.home>
X-Mailer: Claws Mail 3.5.0cvs31 (GTK+ 2.13.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2008 01:51:31 +0200, "J.A. Magallón" <jamagallon@ono.com> wrote:

> Hi...
> 
> I have just got a One, and have installed a standard distro (not Linpus),
> Mandriva in my case.
> 
> Everything works pretty nicely but WiFi. Hardware is:
> 
> 03:00.0 Ethernet controller: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 01)
> 
> The driver used is ath5k. On load, it logs this:
> 
> 
> Aug 15 01:13:57 one klogd: ath5k_pci 0000:03:00.0: registered as 'phy0'
> Aug 15 01:13:57 one klogd: ath5k phy0: Support for RF2425 is under development.
> Aug 15 01:13:57 one klogd: ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
> 

Thanks to everyone that answered, probably the solution is an update to
the driver, hardware support for this chip was added in 27-rc.
My distro still uses 26.2.

I'm going on holydays for a week now, will make more tests on return,
and continue the thread.

Thanks everyone.

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
