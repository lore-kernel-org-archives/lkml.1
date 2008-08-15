Return-Path: <linux-kernel-owner+w=401wt.eu-S1759323AbYHOOEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbYHOOEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 10:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbYHOOEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 10:04:25 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2818 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137AbYHOOEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 10:04:24 -0400
Date: Fri, 15 Aug 2008 09:52:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ath5k on the Acer Aspire One
Message-ID: <20080815135235.GD5183@tuxdriver.com>
References: <20080815015131.39bb20ef@werewolf.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080815015131.39bb20ef@werewolf.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 01:51:31AM +0200, J.A. Magallón wrote:
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

2425 stuff went in after 2.6.26 was already released.  Try linux-2.6.git.

John
-- 
John W. Linville
linville@tuxdriver.com
