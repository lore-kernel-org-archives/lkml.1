Return-Path: <linux-kernel-owner+w=401wt.eu-S1751846AbZGFP4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbZGFP4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 11:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbZGFP4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 11:56:14 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36358 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbZGFP4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 11:56:13 -0400
Date: Mon, 6 Jul 2009 17:56:15 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Michael Abbott <michael@araneidae.co.uk>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Re: /proc/uptime idle counter remains at 0
In-Reply-To: <Pine.LNX.4.64.0907031206420.27250@venus.araneidae.co.uk>
Message-ID: <alpine.LSU.2.00.0907061755460.15898@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0905181421300.1088@venus.araneidae.co.uk> <20090525122820.044e1e35@skybase> <Pine.LNX.4.64.0907031206420.27250@venus.araneidae.co.uk>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2009-07-06 17:48, Michael Abbott wrote:
>[...]
>why am I still allowing uptime to overflow in a year and four months or 
>so?

Is not this addressed by 64-bit jiffies already?

