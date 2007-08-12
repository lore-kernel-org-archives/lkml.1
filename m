Return-Path: <linux-kernel-owner+w=401wt.eu-S934651AbXHLM0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934651AbXHLM0h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 08:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761208AbXHLM0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 08:26:30 -0400
Received: from 212-41-248-74.c-wtaubstummengasse.xdsl-line.inode.at ([212.41.248.74]:4274
	"EHLO s.bksys.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758126AbXHLM03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 08:26:29 -0400
Message-ID: <46BEFC6A.2010705@bksys.at>
Date: Sun, 12 Aug 2007 14:26:18 +0200
From: Bernhard Kuemel <bernhard@bksys.at>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: menuconfig should wrap long lines
References: <46BC804D.6050804@bksys.at> <46BC8714.3010901@bksys.at> <Pine.LNX.4.64.0708121248140.28963@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708121248140.28963@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
>> Ohh, you can scroll right/left.
> 
> But still, that takes its time... and the you have to scroll back again :-/

Yes, but in most cases no scrolling is neccessary, so occasional
scrolling is not that bad. However, I found some long prompts are
clipped, too, and there you can not scroll because <left>/<right>
switches between <Select>, <Exit> and <Help>. The complete prompt
can be found in the help screen with scrolling. E.g.:

  │ │    <M>   DiskOnChip 2000, Millennium and Millennium Plus (NAND
reimp│ │

  │ Prompt: DiskOnChip 2000, Millennium and Millennium Plus (NAND
reimplementation) (EXPERIMENTAL) │

Again, most prompts are sufficiently readable on an 80 character
terminal.

Bernhard

-- 
Please encrypt all emails
GPG Key (ID F732FBF3 E4219D48) available on public key servers
Fingerprint E18F BF4D 0EE2 6522 E950  A06A F732 FBF3 E421 9D48
