Return-Path: <linux-kernel-owner+w=401wt.eu-S936465AbYBVOE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936465AbYBVOE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1769946AbYBVOB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:01:26 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58732 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763426AbYBVOBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:01:24 -0500
Date: Fri, 22 Feb 2008 15:01:42 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
Subject: Re: [RFC/PATCH] Update coding standard to avoid ungrepable printk format strings
Message-ID: <20080222140142.GA23221@one.firstfloor.org>
References: <20080222132612.GA11717@basil.nowhere.org> <47BED3C3.5020500@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BED3C3.5020500@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Instead of a new recommendation (from now on we recommend something
> contrary to what we required up until yesterday --- let's go unwrap
> strings everywhere in the kernel now), how about simply saying that
> printk format strings are not subject to the 80 column rule?

I personally slightly prefer the "unindent" solution over the ">80char"
solution, but it is not a very strong preference and both would be ok
for me.

-Andi
