Return-Path: <linux-kernel-owner+w=401wt.eu-S1758071AbXJKQH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbXJKQH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 12:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbXJKQHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 12:07:52 -0400
Received: from mlbe2k2.cs.myharris.net ([137.237.90.89]:48512 "EHLO
	mlbe2k2.cs.myharris.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbXJKQHv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 12:07:51 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: Aggregation in embedded context, is kernel GPL2 prejudiceagainst embedded systems?
Date: Thu, 11 Oct 2007 12:06:14 -0400
Message-ID: <E496871456016F4CA8959BE4105D2A890E8D7C@troe2k1.cs.myharris.net>
In-Reply-To: <20071011151543.GX16424@stusta.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Aggregation in embedded context, is kernel GPL2 prejudiceagainst embedded systems?
Thread-Index: AcgMGXppR9bNKgCDQUSqjl6p/n7HJAABK8nw
References: <E496871456016F4CA8959BE4105D2A890E8D76@troe2k1.cs.myharris.net> <20071011151543.GX16424@stusta.de>
From: "Crane, Matthew" <mcrane03@harris.com>
To: "Adrian Bunk" <bunk@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 Oct 2007 16:06:15.0990 (UTC) FILETIME=[A6F94560:01C80C20]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

I wasn't sure how to describe what the people and groups with the
mandate to defend open source software.  There are people and groups
with such a mandate.

I'm asking if in a legal sense the grayness is affected by the
constraints of the hw the kernel is being run on, and some attempt to
quantify how the grayness is affected.  Of course it is not black and
white and ultimately up to a judge. 

I realize similar questions have been asked for more then a decade.
What is generally practiced and accepted does change, and any judge
weighing a case wrt these issues would consider that.

Matt



-----Original Message-----
From: Adrian Bunk [mailto:bunk@kernel.org] 
Sent: Thursday, October 11, 2007 11:16 AM
To: Crane, Matthew
Cc: linux-kernel@vger.kernel.org
Subject: Re: Aggregation in embedded context, is kernel GPL2
prejudiceagainst embedded systems?

On Thu, Oct 11, 2007 at 10:33:28AM -0400, Crane, Matthew wrote:
> Hi,

Hi Matthew,

>... 
> If that is what is normal for embedded systems, wouldn't the
expectation
> of what is reasonable for "mere aggregation" be similarly different?
> I've read much FUD about how anything linked statically is instantly a
> derived work.   I do not think it is so black and white.  To me this
> seems to pre-suppose that the option to load modules dynamically
always
> exists.   I do believe that if it does exist, it should be taken, and
> that the interface boundaries always need to be respected regardless,
to
> the point of not using kernel headers and limiting the number of calls
> to EXPORT_SYMBOL functions to the absolute minimum.

even for dynamically linking including non-GPL code is not white but 
already dark grey.

> So would the persons responsible for defending the kernel GPL make
> allowance for the minimal options for separation in a system so
resource
> constrained that it makes sense only to link statically?  I am trying
to
> make a case that this is ok because that is what systems similar in hw
> specs generally due to save resources, and that many examples of an
> "embedded" style of aggregation exist.
>...

There are no "persons responsible for defending the kernel GPL", there 
are just a few hundreds or thousands copyright holders of the kernel,
and each of them has the right to sue you if he thinks you distribute 
something that violates his copyright. Jurisdiction and applicable 
copyright law depends on things like where the copyright holder lives 
and where you distribute it.

> Matt

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

