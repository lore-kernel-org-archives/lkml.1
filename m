Return-Path: <linux-kernel-owner+w=401wt.eu-S1762263AbXHGKlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762263AbXHGKlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 06:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbXHGKlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 06:41:46 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:4051 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755102AbXHGKlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 06:41:45 -0400
Message-ID: <46B84C59.5090506@interia.pl>
Date: Tue, 07 Aug 2007 12:41:29 +0200
From: =?UTF-8?B?UmFmYcWCIEJpbHNraQ==?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
Cc: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       David Edwards <powertop@dpe.lusars.net>, power@bughost.org,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: HPET force-enable investigations on Via VT8235
References: <20070806204249.GA25957@rhlx01.hs-esslingen.de> <46B79512.6090704@interia.pl> <20070806235752.1e6c5653@laptop.hypervisor.org> <46B82F2B.7010704@interia.pl> <20070807090247.GA5806@rhlx01.hs-esslingen.de>
In-Reply-To: <20070807090247.GA5806@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-EMID: 95a18acc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> BTW, is there any obvious chipset ecosystem difference
> in your system? Are any other important PCI IDs/revs
> different from mine?
I don't see any differences.
00:00.0 Host bridge [0600]: VIA Technologies, Inc. VT8623 [Apollo CLE266] [1106:3123]
00:01.0 PCI bridge [0604]: VIA Technologies, Inc. VT8633 [Apollo Pro266 AGP] [1106:b091]
00:0d.0 FireWire (IEEE 1394) [0c00]: VIA Technologies, Inc. IEEE 1394 Host Controller [1106:3044] (rev 80)
00:10.0 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 80)
00:10.1 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 80)
00:10.2 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 80)
00:10.3 USB Controller [0c03]: VIA Technologies, Inc. USB 2.0 [1106:3104] (rev 82)
00:11.0 ISA bridge [0601]: VIA Technologies, Inc. VT8235 ISA Bridge [1106:3177]
00:11.1 IDE interface [0101]: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE [1106:0571] (rev 06)
00:11.5 Multimedia audio controller [0401]: VIA Technologies, Inc. VT8233/A/8235/8237 AC97 Audio Controller [1106:3059] (rev 50)
00:12.0 Ethernet controller [0200]: VIA Technologies, Inc. VT6102 [Rhine-II] [1106:3065] (rev 74)
00:14.0 Multimedia controller [0480]: Philips Semiconductors SAA7134/SAA7135HL Video Broadcast Decoder [1131:7134] (rev 01)
01:00.0 VGA compatible controller [0300]: VIA Technologies, Inc. VT8623 [Apollo CLE266] integrated CastleRock graphics [1106:3122] (rev 03)

> Andreas Mohr
Regards
Rafał

----------------------------------------------------------------------
Plaza plazy nierowna
Kliknij
>>>http://link.interia.pl/f1af7

