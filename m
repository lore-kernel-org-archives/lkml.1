Return-Path: <linux-kernel-owner+w=401wt.eu-S1762191AbXH3Tic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762191AbXH3Tic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 15:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760248AbXH3TiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 15:38:25 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:37210 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760039AbXH3TiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 15:38:24 -0400
Date: Thu, 30 Aug 2007 21:38:23 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Al Boldi <a1426z@gawab.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       dex@dragonslave.de
Subject: Re: [PATCH] Override 80-wire cable detection for Toshiba S1800-814
In-Reply-To: <200708301654.22346.a1426z@gawab.com>
Message-ID: <Pine.LNX.4.64.0708302135560.24730@fbirervta.pbzchgretzou.qr>
References: <200708300731.20336.a1426z@gawab.com> <20070830110144.1e8020ec@the-village.bc.nu>
 <200708301654.22346.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 30 2007 16:54, Al Boldi wrote:
>
>What's the max length of a 40wire cable to sustain 80wire cable 
>characteristics?

Hard to tell, since some (most?) laptops have sort of a backplane and there
might be no real cable you could see because it's all mainboard wire paths
already.


	Jan
-- 
