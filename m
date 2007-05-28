Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbXE1KtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbXE1KtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 06:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbXE1Ksy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 06:48:54 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1331 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbXE1Ksx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 06:48:53 -0400
Message-ID: <465AB38E.4020604@shadowen.org>
Date: Mon, 28 May 2007 11:48:46 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker
References: <9a1288909c10f2935af82ec5cea0c46b@pinky> <20070527101023.9c4f5952.randy.dunlap@oracle.com>
In-Reply-To: <20070527101023.9c4f5952.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Sun, 27 May 2007 18:11:25 +0100 Andy Whitcroft wrote:
> 
>> 	Also if either Joel or Randy want to be on on the MAINTAINERS
>> 	entry yell and we'll get it updated, wouldn't want to list
>> 	anyone without permission.
> 
> Yes, please.
> 
>> 	I have the infrastructure in place to for the automated robot
>> 	if and when its deemed ready.
>>
>> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
>> index a417b25..23637e8 100644
>> --- a/Documentation/SubmittingPatches
>> +++ b/Documentation/SubmittingPatches
> 
> It needs to be added to Documentation/SubmitChecklist also...
> (but I'm working in yard/house this holiday-not weekend).

So true.

I've sorted this one out, but there seems to be a number of little
changes trickling in so I will roll them all up and send up a V2 pretty
soon.

-apw
