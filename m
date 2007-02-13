Return-Path: <linux-kernel-owner+w=401wt.eu-S1751295AbXBMMEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbXBMMEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 07:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbXBMMEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 07:04:35 -0500
Received: from lazybastard.de ([212.112.238.170]:42395 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbXBMMEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 07:04:35 -0500
Date: Tue, 13 Feb 2007 11:59:35 +0000
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Arjan van de Ven <arjan@infradead.org>, "Martin A. Fink" <fink@mpe.mpg.de>,
       Matthias Schniedermeyer <ms@citd.de>, linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
Message-ID: <20070213115935.GA12383@lazybastard.org>
References: <200702121502.17130.fink@mpe.mpg.de> <200702121856.29729.fink@mpe.mpg.de> <45D0F8EE.7020604@citd.de> <200702131025.15964.fink@mpe.mpg.de> <1171361290.12771.77.camel@laptopd505.fenrus.org> <20070213112758.5920a28e@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070213112758.5920a28e@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 February 2007 11:27:58 +0000, Alan wrote:
> 
> isn't yet a heavily optimised libata path. Secondly erase block size
> matters with flash drives so the bigger each I/O the better erase block
> behaviour we should get.

Although that should max out somewhere between 16KiB and 128KiB,
depending on the chips being used.

Jörn

-- 
If you're willing to restrict the flexibility of your approach,
you can almost always do something better.
-- John Carmack
