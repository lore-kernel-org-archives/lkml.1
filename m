Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbXLEK7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbXLEK7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 05:59:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbXLEK7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 05:59:24 -0500
Received: from orion2.pixelized.ch ([195.190.190.13]:43484 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbXLEK7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 05:59:23 -0500
Message-ID: <47568481.50802@cateee.net>
Date: Wed, 05 Dec 2007 11:59:13 +0100
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Diego Calleja <diegocg@gmail.com>
CC: "" <jamagallon@ono.com>, linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
References: <474EAD18.6040408@stellatravel.co.uk>	<20071130143445.GA2310@csclub.uwaterloo.ca>	<53ADBDBF-9B65-441E-B867-D68DE48ABD64@mac.com>	<4751BE0D.3050609@argo.co.il>	<p733aukyl8n.fsf@bingen.suse.de>	<47539030.10600@argo.co.il>	<20071203095022.GA28560@one.firstfloor.org>	<4753ECA5.2010604@argo.co.il>	<20071203211353.GA4009@1wt.eu>	<20071203223902.1194aa69@werewolf>	<20071203215727.543fc757@the-village.bc.nu>	<20071204224745.51e6c2b1@werewolf> <20071204232045.212ba1bf.diegocg@gmail.com>
In-Reply-To: <20071204232045.212ba1bf.diegocg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Diego Calleja wrote:
> El Tue, 4 Dec 2007 22:47:45 +0100, "J.A. Magallón" <jamagallon@ono.com> escribió:
> 
>> That is what I like of C++, with good placement of high level features
>> like const's and & (references) one can gain fine control over what
>> gets copied or not.
> 
> But...if there's some way Linux can get "language improvements", is with
> new C standards/gccextensions/etc. It'd be nice if people tried to add
> (useful) C extensions to gcc, instead of proposing some random language :)

But nobody know such extensions.
I think that the core kernel will remain in C, because
there are no problems and no improvement possible
(with other language)

But the drivers side has more problems. There is a lot
of copy-paste, quality is often not high, not all developers
know well linux kernel, and not well maintained with new
or better internal API. So if we found a good template
or a good language to help *some* drivers without
causing a lot of problem to the rest of community, it would
be nice.

I don't think that we have written in stone that kernel
drivers should be written only in C, but actually there is
no good alternative.

But I think it is a huge task to find a language, a
prototype of API and convert some testing drivers.
And there is no guarantee of good result.

ciao
	cate
