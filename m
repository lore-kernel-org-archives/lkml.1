Return-Path: <linux-kernel-owner+w=401wt.eu-S935202AbXHLNVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935202AbXHLNVp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 09:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbXHLNVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 09:21:37 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:55749 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbXHLNVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 09:21:36 -0400
Date: Sun, 12 Aug 2007 15:21:35 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Bernhard Kuemel <bernhard@bksys.at>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>, sam@ravnborg.org
Subject: Re: menuconfig should wrap long lines
In-Reply-To: <46BEFC6A.2010705@bksys.at>
Message-ID: <Pine.LNX.4.64.0708121519450.28963@fbirervta.pbzchgretzou.qr>
References: <46BC804D.6050804@bksys.at> <46BC8714.3010901@bksys.at>
 <Pine.LNX.4.64.0708121248140.28963@fbirervta.pbzchgretzou.qr>
 <46BEFC6A.2010705@bksys.at>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-340941167-1186924895=:28963"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-340941167-1186924895=:28963
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Aug 12 2007 14:26, Bernhard Kuemel wrote:
>Jan Engelhardt wrote:
>>>>[menuconfig]
>>>
>>> Ohh, you can scroll right/left.
>> 
>> But still, that takes its time... and the you have to scroll back again :-/
>
>Yes, but in most cases no scrolling is neccessary, so occasional
>scrolling is not that bad.

It is, on long lines, if you are trying to figure out the selects line.

>However, I found some long prompts are
>clipped, too, and there you can not scroll because <left>/<right>
>switches between <Select>, <Exit> and <Help>. The complete prompt
>can be found in the help screen with scrolling. E.g.:
>
>  │ │    <M>   DiskOnChip 2000, Millennium and Millennium Plus (NAND
>reimp│ │
>
>  │ Prompt: DiskOnChip 2000, Millennium and Millennium Plus (NAND
>reimplementation) (EXPERIMENTAL) │
>
>Again, most prompts are sufficiently readable on an 80 character
>terminal.


	Jan
-- 
---699020219-340941167-1186924895=:28963--
