Return-Path: <linux-kernel-owner+w=401wt.eu-S1752446AbYJSWMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbYJSWMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 18:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYJSWMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 18:12:33 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39977 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbYJSWMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 18:12:32 -0400
Date: Mon, 20 Oct 2008 00:06:55 +0200
From: Pavel Machek <pavel@suse.cz>
To: jbenc@suse.cz, kernel list <linux-kernel@vger.kernel.org>, i.zhu@intel.com,
       reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net
Subject: Re: iwl3945: if I leave my machine running overnight, wifi will
	not work in the morning
Message-ID: <20081019220655.GA1827@elf.ucw.cz>
References: <20081019214035.GA30485@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081019214035.GA30485@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-10-19 23:40:35, Pavel Machek wrote:
> Hi!
> 
> Kernel 2.6.27-rc8; happened few times already.

...
> After reboot, network will work (I believe ;-).

Hmm, it did not this time.

iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver
for Linux, 1.2.26kds
iwl3945: Copyright(c) 2003-2008 Intel Corporation
iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwl3945 0000:03:00.0: setting latency timer to 64
iwl3945: Detected Intel Wireless WiFi Link 3945ABG
iwl3945: Tunable channels: 11 802.11bg, 13 802.11a channels
phy0: Selected rate control algorithm 'iwl-3945-rs'
iwl3945 0000:03:00.0: PCI INT A disabled
Linux video capture interface: v2.00
Uniform Multi-Platform E-IDE driver
...
Oct 20 00:06:25 amd kernel: wlan0: RX ReassocResp from 00:11:2f:0e:95:a0 (capab=0x401 status=0 aid=1)
Oct 20 00:06:25 amd kernel: wlan0: associated
Oct 20 00:06:26 amd kernel: wlan0: disassociated
Oct 20 00:06:27 amd kernel: wlan0: associate with AP 00:11:2f:0e:95:a0
Oct 20 00:06:27 amd kernel: wlan0: RX ReassocResp from 00:11:2f:0e:95:a0 (capab=0x401 status=0 aid=1)
Oct 20 00:06:27 amd kernel: wlan0: associated
Oct 20 00:06:27 amd kernel: wlan0: disassociated
Oct 20 00:06:28 amd kernel: wlan0: associate with AP 00:11:2f:0e:95:a0
Oct 20 00:06:28 amd kernel: wlan0: RX ReassocResp from 00:11:2f:0e:95:a0 (capab=0x401 status=0 aid=1)
Oct 20 00:06:28 amd kernel: wlan0: associated
Oct 20 00:06:29 amd kernel: wlan0: disassociated

On to reboot the access point...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
