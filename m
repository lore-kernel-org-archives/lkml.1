Return-Path: <linux-kernel-owner+w=401wt.eu-S1753295AbXLNOIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbXLNOIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 09:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbXLNOIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 09:08:10 -0500
Received: from intcomgrp.com ([216.54.13.120]:33458 "EHLO
	beta.support.intcomgrp.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751512AbXLNOIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 09:08:09 -0500
Message-ID: <47628E4C.2090801@intcomgrp.com>
Date: Fri, 14 Dec 2007 09:08:12 -0500
From: James Kosin <jkosin@intcomgrp.com>
Organization: International Communications Group, Inc.
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [RFT] Port 0x80 I/O speed
References: <9A0cz-7xy-13@gated-at.bofh.it> <9A0cz-7xy-11@gated-at.bofh.it> <9A4pU-69z-15@gated-at.bofh.it>
In-Reply-To: <9A4pU-69z-15@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 13-12-07 17:27, James Kosin wrote:
> 
>> model name      : Pentium III (Katmai)
>> cpu MHz         : 499.156
> 
>> [root@beta jkosin]# ./a.out
>> cycles: out 683, in 299
> 
> Thanks much, you made spot 32 ;-)
> 
> http://lkml.org/lkml/2007/12/12/309
> 
> By the way, if anyone in this/these thread(s) wrote something today (*)
> they would like me to reply to -- my horseshit ISP is completely
> crapping out on me and I haven't seen your message. Resends ofcourse
> welcome.
> 
> (*) [now - 16 hours, now]
> 
> Rene.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
Maybe,  I should have added the lspci to the list of information.
kernel version is latest 2.4 kernel.

[root@beta root]# lspci
00:00.0 Host bridge: Intel Corp. 440BX/ZX/DX - 82443BX/ZX/DX Host bridge
(rev 03)
00:01.0 PCI bridge: Intel Corp. 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge
(rev 03)
00:07.0 ISA bridge: Intel Corp. 82371AB/EB/MB PIIX4 ISA (rev 02)
00:07.1 IDE interface: Intel Corp. 82371AB/EB/MB PIIX4 IDE (rev 01)
00:07.2 USB Controller: Intel Corp. 82371AB/EB/MB PIIX4 USB (rev 01)
00:07.3 Bridge: Intel Corp. 82371AB/EB/MB PIIX4 ACPI (rev 02)
00:09.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169
(rev 10)
00:0a.0 Ethernet controller: Lite-On Communications Inc LNE100TX (rev 20)
00:0b.0 VGA compatible controller: ATI Technologies Inc 3D Rage Pro
215GP (rev 5c)

-- 
Scanned by ClamAV - http://www.clamav.net

