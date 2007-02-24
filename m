Return-Path: <linux-kernel-owner+w=401wt.eu-S932808AbXBXPyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932808AbXBXPyk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 10:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932838AbXBXPyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 10:54:39 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:23707 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932808AbXBXPyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 10:54:39 -0500
X-IronPort-AV: i="4.14,215,1170651600"; 
   d="scan'208"; a="28784666:sNHT23339771"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: MOST(Media Oriented Systems Transport) Interface?
Date: Sat, 24 Feb 2007 10:55:24 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200702231826.30395.rgetz@blackfin.uclinux.org> <45DF9915.1010400@redhat.com>
In-Reply-To: <45DF9915.1010400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702241055.24815.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 24 Feb 2007 15:54:37.0726 (UTC) FILETIME=[162DE3E0:01C7582C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 23 Feb 2007 20:47, Rik van Riel wrote:
> Robin Getz wrote:
> > Does anyone have a pointer for a MOST (Media Oriented Systems Transport) driver?
> 
> Are there any applications that use that protocol?

Many - all automotive embedded - If you drive a recent car - from Audi, Aston Martin, Ford, BMW, Honda, Hyundai/Kia, DaimlerChrysler, Jaguar, Land Rover, Nissan, Porsche, Toyota, Volvo, or VW - you may be using it today.

> Specifically, any applications worth caring about?

Again - depends on who you are. If you are one of the above - yes, you care allot. If you are a enthusiast you wants low level access to entertainment system in your car - then you care too.

It is like asking if I should care about applications using 100Base-T - as a user - I just want it to work and I only care when it doesn't work; as a driver developer - I care alot, but am agnostic to the application.


I found a spec that says MOST runs IP - 

http://www.mostcooperation.com/downloads/Specifications/MOST%20Specifications/MAMAC%20Specification

but thought I would ask if anyone else has any public work about the non-IP protocols. 

For those that might care, full spec is at:

http://www.mostcooperation.com/downloads/Specifications/MOST%20Specifications/MOSTSpecification.pdf

-Robin
