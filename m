Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbZBSOA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbZBSOA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 09:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbZBSOAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 09:00:10 -0500
Received: from mail122.emailantidote.com ([80.169.59.122]:51486 "EHLO
	SC-MTA-03.mxsweep.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751846AbZBSOAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 09:00:08 -0500
X-Greylist: delayed 573 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Feb 2009 09:00:08 EST
Message-ID: <499D639E.6090205@draigBrady.com>
Date: Thu, 19 Feb 2009 13:50:22 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: General question (scheduler) with SSDs?
References: <alpine.DEB.1.10.0902190837270.19552@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0902190837270.19552@p34.internal.lan>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Feb 2009 13:50:26.0302 (UTC) FILETIME=[04AF51E0:01C99299]
x-MXSweep-KeywordsCount: 0
x-MXSweep-MetaScanResult: Clean
x-MXSweep-MetaScanThreat: 
x-MXSweep-VirusScanned: OK
x-MXPurifier-SpamScore: 0
x-MXPurifier-VirusScore: 0
x-MXSweep-Threat: Clean
X-MXUniqueID: fb03b1bb-b86c-4a87-be91-d1cc742ca87e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> Hello,
> 
> I was curious if anyone had done any benchmarks and/or has conclusive
> information, what is the best Linux scheduler to use with SSDs?
> 
> Noop?
> CFQ?
> AS?
> Deadline?

There was a thread started on that recently:
http://lkml.org/lkml/2009/1/30/288
