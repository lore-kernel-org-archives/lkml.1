Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbXGNHUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbXGNHUj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 03:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbXGNHUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 03:20:17 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:16059 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbXGNHUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 03:20:16 -0400
Date: Sat, 14 Jul 2007 01:22:10 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.22-rc6-mm1
In-reply-to: <fa.GKNLH/oj9PSCnQCxx9ZAggjc5uA@ifi.uio.no>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-id: <469879A2.1000002@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.GKNLH/oj9PSCnQCxx9ZAggjc5uA@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> +x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
> 
>  pretend to fix it

I'm not sure what this patch does on x86_64, but it seems like it 
trashes all HPET support on i386?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

