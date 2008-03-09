Return-Path: <linux-kernel-owner+w=401wt.eu-S1754207AbYCITa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbYCITa0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 15:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbYCITaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 15:30:15 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:47311 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071AbYCITaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 15:30:14 -0400
X-Sasl-enc: 9a9W1uoX2uyG4QuzrgU5RcWTlXTF+OANL5NxoBtphkat 1205091012
Date: Sun, 9 Mar 2008 16:30:09 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Dave Jones <davej@codemonkey.org.uk>, Andi Kleen <andi@firstfloor.org>,
       Alan Stern <stern@rowland.harvard.edu>, Adam Belay <abelay@novell.com>,
       Lee Revell <rlrevell@joe-job.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080309193009.GD27193@khazad-dum.debian.net>
References: <Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org> <20080303231033.GB15255@one.firstfloor.org> <20080304040048.GA31562@codemonkey.org.uk> <20080304071423.0e6b71c1@mjolnir.drzeus.cx> <20080304181924.70aaf8c1@mjolnir.drzeus.cx> <924EFEDD5F540B4284297C4DC59F3DEEA77031@orsmsx423.amr.corp.intel.com> <20080305070201.0d16cd40@mjolnir.drzeus.cx> <20080305094023.6486ebdf@mjolnir.drzeus.cx> <20080306092730.4412d085@mjolnir.drzeus.cx> <20080309151659.63d54f38@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080309151659.63d54f38@mjolnir.drzeus.cx>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 09 Mar 2008, Pierre Ossman wrote:
> I'm beginning to think this is a lost cause. I've tried several variants, all without satisfactory results.

THIS will work:
http://www.nordichardware.com/image3.php?id=1446

ThinkPad owners have known this for a while...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
