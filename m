Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbZGFQJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbZGFQJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 12:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbZGFQJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 12:09:50 -0400
Received: from araneidae.co.uk ([62.3.233.233]:3514 "EHLO araneidae.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbZGFQJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 12:09:49 -0400
X-Greylist: delayed 1262 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jul 2009 12:09:49 EDT
Date: Mon, 6 Jul 2009 17:09:51 +0100 (BST)
From: Michael Abbott <michael@araneidae.co.uk>
To: Jan Engelhardt <jengelh@medozas.de>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Re: /proc/uptime idle counter remains at 0
In-Reply-To: <alpine.LSU.2.00.0907061755460.15898@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0907061709090.11605@venus.araneidae.co.uk>
References: <Pine.LNX.4.64.0905181421300.1088@venus.araneidae.co.uk>
 <20090525122820.044e1e35@skybase> <Pine.LNX.4.64.0907031206420.27250@venus.araneidae.co.uk>
 <alpine.LSU.2.00.0907061755460.15898@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009, Jan Engelhardt wrote:
> On Monday 2009-07-06 17:48, Michael Abbott wrote:
> >[...]
> >why am I still allowing uptime to overflow in a year and four months or 
> >so?
> Is not this addressed by 64-bit jiffies already?

Possibly, sorry, not terribly familiar with the underlying infrastructure,
just trying to fix one bug without being dragged under by all the rest!

