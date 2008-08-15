Return-Path: <linux-kernel-owner+w=401wt.eu-S1759318AbYHOUHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbYHOUHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 16:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbYHOUHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 16:07:32 -0400
Received: from qb-out-0506.google.com ([72.14.204.225]:59550 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbYHOUHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 16:07:31 -0400
Message-ID: <e700089d0808151307j27d6c61dw3a1dd174e4e8610c@mail.gmail.com>
Date: Fri, 15 Aug 2008 16:07:29 -0400
From: "Yousaf Jindal" <yousaf.jindal@pi.edu.pk>
To: thomas.winkler@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Wifi Link 5300 and 5100 Series
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 00:11 Thu 14 Aug     , Tomas Winkler wrote:
>> Intel would like to announce Linux support  for Wifi Link 5000 and
>> 5100 Series Adapters under iwlwifi driver (iwlagn.ko)
>>
> ...
>> The best known working driver can be located in iwl500 branch of
>> iwlwifi-2.6.git
>> git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git iwl5000



I am using the iwl500 branch from the above git repository and I am
also receiving the timeout error. This is on a Wifi Link 5100 on an
Asus M50VM laptop.

$ dmesg|grep iw
[    8.574423] iwlagn: Intel(R) Wireless WiFi Link AGN driver for
Linux, 1.3.27kds
[    8.574655] iwlagn: Copyright(c) 2003-2008 Intel Corporation
[    8.575055] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    8.575369] iwlagn 0000:03:00.0: setting latency timer to 64
[    8.575425] iwlagn: Detected Intel Wireless WiFi Link 5100AGN REV=0x54
[    8.607886] iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
[    8.609136] iwlagn 0000:03:00.0: PCI INT A disabled
[    8.608701] phy0: Selected rate control algorithm 'iwl-agn-rs'
[   19.311948] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   19.312260] iwlagn 0000:03:00.0: restoring config space at offset
0x1 (was 0x100002, writing 0x100006)
[   19.312442] firmware: requesting iwlwifi-5000-1.ucode
[   23.459172] iwlagn: START_ALIVE timeout after 4000ms.
[   23.459318] iwlagn 0000:03:00.0: PCI INT A disabled


-- Yousaf

-- 
Yousaf Jindal
Director of Technology
Pakistani Institute
