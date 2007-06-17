Return-Path: <linux-kernel-owner+w=401wt.eu-S1760943AbXFQULA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760943AbXFQULA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 16:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759871AbXFQUKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 16:10:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:60419 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757634AbXFQUKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 16:10:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=f0I3UdYtIJT+xwbFFi520sxvHzqSpAePyUxx32pHxTWlfauHCs9JWY+VqS7z3cx5l3CVi+jRv5o7/PZvNQ8hxjicig7k/s533JG8yAMJx2lxuSrVYyUwrc3bfiMsGlGbCpiQjUF9JnDb7YlspRRpQPrtw2k066L9wtHyiZH1Ww8=
Message-ID: <6bffcb0e0706171310o3b486a64sda36744dce8b52cd@mail.gmail.com>
Date: Sun, 17 Jun 2007 22:10:51 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: How to improve the quality of the kernel?
Cc: "Carlo Wood" <carlo@alinoe.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Adrian Bunk" <bunk@stusta.de>, "Oleg Verych" <olecom@flower.upol.cz>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andi Kleen" <andi@firstfloor.org>, "Diego Calleja" <diegocg@gmail.com>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <467592D7.8050300@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org>
	 <200706172053.41806.bzolnier@gmail.com>
	 <20070617115258.1f55b29d.akpm@linux-foundation.org>
	 <200706172118.19214.rjw@sisk.pl> <20070617193356.GB20727@alinoe.com>
	 <467592D7.8050300@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/06/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Carlo Wood wrote:
> > On Sun, Jun 17, 2007 at 09:18:17PM +0200, Rafael J. Wysocki wrote:
> >> where n is a number that needs to be determined (I think that n could be 3).
> >> Well, "negative comments" should also be defined more precisely. ;-)
> >
> > I think that n should be a function of the number of accepted patches
> > that this person sent in before, and the number of regressions he
> > caused in the past.
>
> The character of the patch (potential impacts, size...) and availability
> of reviewers and testers influence the required review time so much that
> other factors, like reputation of the submitter, hardly matter.

So we need a bug/regression/patch tracking system based on MMORPG game ;)

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
