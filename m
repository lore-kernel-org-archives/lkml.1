Return-Path: <linux-kernel-owner+w=401wt.eu-S933270AbXH3Twi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270AbXH3Twi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 15:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932708AbXH3Twa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 15:52:30 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:48845 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbXH3Twa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 15:52:30 -0400
Date: Thu, 30 Aug 2007 21:52:29 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
cc: Al Boldi <a1426z@gawab.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, dex@dragonslave.de
Subject: Re: [PATCH] Override 80-wire cable detection for Toshiba S1800-814
In-Reply-To: <20070830194740.GC11130@csclub.uwaterloo.ca>
Message-ID: <Pine.LNX.4.64.0708302152120.24730@fbirervta.pbzchgretzou.qr>
References: <200708300731.20336.a1426z@gawab.com> <20070830110144.1e8020ec@the-village.bc.nu>
 <200708301654.22346.a1426z@gawab.com> <Pine.LNX.4.64.0708302135560.24730@fbirervta.pbzchgretzou.qr>
 <20070830194740.GC11130@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 30 2007 15:47, Lennart Sorensen wrote:
>On Thu, Aug 30, 2007 at 09:38:23PM +0200, Jan Engelhardt wrote:
>> Hard to tell, since some (most?) laptops have sort of a backplane and there
>> might be no real cable you could see because it's all mainboard wire paths
>> already.
>
>Makes you wonder why the mainboard doesn't just pretend to be an 80 wire
>cable if that is what it is compatible with.  Seems like a design flaw
>in the laptop to not do so.

Or lazyness on behalf the vendor. You know, some even don't fix their DSDT...


	Jan
-- 
