Return-Path: <linux-kernel-owner+w=401wt.eu-S1030526AbXAaSkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030526AbXAaSkj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 13:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030533AbXAaSkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 13:40:39 -0500
Received: from mga07.intel.com ([143.182.124.22]:6466 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030526AbXAaSki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 13:40:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,263,1167638400"; 
   d="scan'208"; a="175408702:sNHT287319200"
Message-ID: <45C0E2A0.5090202@foo-projects.org>
Date: Wed, 31 Jan 2007 10:40:32 -0800
From: Auke Kok <sofar@foo-projects.org>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: wsl3@lrsehosting.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unidentified Intel wifi network card
References: <1170264624.5569.15.camel@scott-640m>
In-Reply-To: <1170264624.5569.15.camel@scott-640m>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Jan 2007 18:40:33.0018 (UTC) FILETIME=[4A14E5A0:01C74567]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Lockwood wrote:
> I'm looking for assistance with a wifi device I can't find a driver for,
> the Intel Wireless 3945.
> 
> I"m getting this:
> 
> 0000:0c:00.0 Network controller: Intel Corporation: Unknown device 4222
> (rev 02)
> 
> on a new Dell Latitude D820. Anyone know if there will be an open source
> driver for this any time soon, or if there is one now?
> 
> I'm using the latest vendor supplied kernel, so my apologies if this has
> already been done and I'm late to the party. I wasn't able to find much,
> other than 'use the NDIS wrapper' which I really don't want to do.

http://ipw3945.sourceforge.net/

Cheers,

Auke




PS google for '3945 driver linux' also showed this as #1 hit:
http://www.google.com/search?q=3945+driver+linux
