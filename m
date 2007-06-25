Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbXFYQeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbXFYQeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 12:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbXFYQeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 12:34:08 -0400
Received: from lucidpixels.com ([75.144.35.66]:47285 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbXFYQeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 12:34:07 -0400
Date: Mon, 25 Jun 2007 12:34:05 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-Reply-To: <467FEDE6.3080500@macroscoop.nl>
Message-ID: <Pine.LNX.4.64.0706251233440.15590@p34.internal.lan>
References: <200706071530.51552.jesse.barnes@intel.com>
 <200706141418.42082.jbarnes@virtuousgeek.org> <4672681D.7020601@macroscoop.nl>
 <200706150920.24490.jbarnes@virtuousgeek.org> <467A8A20.7000302@macroscoop.nl>
 <467FEDE6.3080500@macroscoop.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Impressive.

Jesse, can you touch base with Intel's BIOS department?  Also, what are 
the chances of that patch making it into 2.6.22-rc6/7 if it hasn't 
already?

On Mon, 25 Jun 2007, Pim Zandbergen wrote:

> Pim Zandbergen wrote
>>> 
>> I reported this to GigaByte, and lo and behold, they sent me a fixed BIOS 
>> within 48 hours.
>> Kudos to Taipeh!
>> 
>> They sent the BIOS image in a private message, so it might take a while 
>> before it's available
>> on their website.
> It is now, and it is described as "Fix Vista boot lag with 8GB memory issue" 
> ...
>
> Pim
>
