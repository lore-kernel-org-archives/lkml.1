Return-Path: <linux-kernel-owner+w=401wt.eu-S1759055AbXJKPP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055AbXJKPP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 11:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbXJKPPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 11:15:18 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46715 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755122AbXJKPPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 11:15:17 -0400
Date: Thu, 11 Oct 2007 17:15:43 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Crane, Matthew" <mcrane03@harris.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Aggregation in embedded context, is kernel GPL2 prejudice
	against embedded systems?
Message-ID: <20071011151543.GX16424@stusta.de>
References: <E496871456016F4CA8959BE4105D2A890E8D76@troe2k1.cs.myharris.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <E496871456016F4CA8959BE4105D2A890E8D76@troe2k1.cs.myharris.net>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 10:33:28AM -0400, Crane, Matthew wrote:
> Hi,

Hi Matthew,

>... 
> If that is what is normal for embedded systems, wouldn't the expectation
> of what is reasonable for "mere aggregation" be similarly different?
> I've read much FUD about how anything linked statically is instantly a
> derived work.   I do not think it is so black and white.  To me this
> seems to pre-suppose that the option to load modules dynamically always
> exists.   I do believe that if it does exist, it should be taken, and
> that the interface boundaries always need to be respected regardless, to
> the point of not using kernel headers and limiting the number of calls
> to EXPORT_SYMBOL functions to the absolute minimum.

even for dynamically linking including non-GPL code is not white but 
already dark grey.

> So would the persons responsible for defending the kernel GPL make
> allowance for the minimal options for separation in a system so resource
> constrained that it makes sense only to link statically?  I am trying to
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

