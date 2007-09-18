Return-Path: <linux-kernel-owner+w=401wt.eu-S1761027AbXIRRjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761027AbXIRRjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757935AbXIRRjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:39:05 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:20271 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760060AbXIRRjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:39:04 -0400
Message-ID: <46F00D38.8090002@cfl.rr.com>
Date: Tue, 18 Sep 2007 13:39:04 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: konstantin.sharlaimov@gmail.com
CC: Justin Piszcz <jpiszcz@lucidpixels.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22.1: Enabling IO-APIC = APIC error on CPU0: 40(40)
References: <Pine.LNX.4.64.0707140758110.22713@p34.internal.lan>  <1190034476.8152.8.camel@traveler>  <Pine.LNX.4.64.0709170909520.8681@p34.internal.lan> <1190034991.8152.14.camel@traveler>
In-Reply-To: <1190034991.8152.14.camel@traveler>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Sep 2007 17:39:09.0952 (UTC) FILETIME=[D1D02000:01C7FA1A]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1021-15432.000
X-TM-AS-Result: No--11.110800-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Sharlaimov wrote:
> I agree, this is probably somehow related with SiS chipset - my laptop
> has one of these SiS 760 host controllers inside. 
> 
> I'll probably do some digging to figure out if this is indeed chipset
> related. I wonder if this error occurs under Windows (Win does not
> report much, yet it's kernel must be aware of such error).

Windows does not use IO-APICs AFAIK.

