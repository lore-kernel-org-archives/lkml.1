Return-Path: <linux-kernel-owner+w=401wt.eu-S1763080AbZFNVn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763080AbZFNVn6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 17:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757600AbZFNVnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 17:43:50 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35316 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104AbZFNVnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 17:43:50 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A356F0E.9020809@s5r6.in-berlin.de>
Date: Sun, 14 Jun 2009 23:43:42 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090523 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Ben Dooks <ben-linux@fluff.org>
CC: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: dma-debug: check_for_stack background?
References: <4A3547DD.2010809@s5r6.in-berlin.de> <20090614212018.GD20442@fluff.org.uk>
In-Reply-To: <20090614212018.GD20442@fluff.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Dooks wrote:
> On Sun, Jun 14, 2009 at 08:56:29PM +0200, Stefan Richter wrote:
>> the DMA debug facility warns  
>> about mappings of on-stack memory.  What's the problem with that?
...
> I'm not sure if it is possible on all architectures, however the
> DMA mapping documentation prohibts the use of stack memory.

Ah, it has all been documented in plain sight for ages.  Thanks for the 
pointer.
-- 
Stefan Richter
-=====-==--= -==- -===-
http://arcgraph.de/sr/
