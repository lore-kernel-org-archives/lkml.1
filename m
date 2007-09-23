Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbXIWTYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbXIWTYJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 15:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbXIWTX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 15:23:57 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4863 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746AbXIWTX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 15:23:56 -0400
Subject: Re: [RFC] New kernel-message logging API
From: Joe Perches <joe@perches.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       holzheu <holzheu@linux.vnet.ibm.com>, Rob Landley <rob@landley.net>,
       Dick Streefland <dick.streefland@altium.nl>
In-Reply-To: <Pine.LNX.4.64.0709231044290.15712@fbirervta.pbzchgretzou.qr>
References: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com>
	 <1190506383.30132.11.camel@localhost>
	 <19f34abd0709230139s56b9a9b1yc2cae89488ea5112@mail.gmail.com>
	 <Pine.LNX.4.64.0709231044290.15712@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Sun, 23 Sep 2007 12:23:50 -0700
Message-Id: <1190575430.30132.45.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-23 at 10:45 +0200, Jan Engelhardt wrote:
> I'd rather fix up code to reduce its indent rather than
> trying microoptimizations at the function name level!

I think that's a different discussion.

You could fix some of them whenever you like.

$ egrep -r -l --include=*.c "^[[:cntrl:]]{6,}printk" *

cheers, Joe

