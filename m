Return-Path: <linux-kernel-owner+w=401wt.eu-S1752468AbZHaOlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbZHaOlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 10:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbZHaOlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 10:41:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40034 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbZHaOlQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 10:41:16 -0400
From: "Syed Mohammed, Khasim" <khasim@ti.com>
To: Steve Sakoman <sakoman@gmail.com>, Artem Bityutskiy <dedekind1@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org Mailing List" 
	<linux-omap@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>,
       Tomi Valkeinen <tomi.valkeinen@nokia.com>
Date: Mon, 31 Aug 2009 20:10:59 +0530
Subject: RE: [PATCH 00/18] OMAP: DSS2: Intro
Thread-Topic: [PATCH 00/18] OMAP: DSS2: Intro
Thread-Index: AcoqR0n2W0I5RdOXR5+xDReB8va5ogAAQjmQ
Message-ID: <0680EC522D0CC943BC586913CF3768C0037CE48136@dbde02.ent.ti.com>
References: <1251462337-12531-1-git-send-email-tomi.valkeinen@nokia.com>
	 <4A9B96A7.5040005@gmail.com>
 <5e088bd90908310720p290ba68dwd6106a778fd7c740@mail.gmail.com>
In-Reply-To: <5e088bd90908310720p290ba68dwd6106a778fd7c740@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-owner@vger.kernel.org] On Behalf Of Steve
> Sakoman
> Sent: Monday, August 31, 2009 7:50 PM
> To: Artem Bityutskiy
> Cc: Andrew Morton; Tony Lindgren; Tomi Valkeinen; linux-kernel@vger.kernel.org; linux-
> omap@vger.kernel.org Mailing List
> Subject: Re: [PATCH 00/18] OMAP: DSS2: Intro
> 
> On Mon, Aug 31, 2009 at 2:23 AM, Artem Bityutskiy<dedekind1@gmail.com> wrote:
> 
> > We are using DSS2 in Nokia for about a year already. N900 is using this
> > code, for example. Other (non-Nokia) projects are using DSS2 as well.
> > The code was public for long time and was sent several times for review.
> >
> > In any case,
> >
> > Tested-by: Artem Bityutskiy <artem.bityutskiy@nokia.com>
> 
> Gumstix has also been shipping with DSS2 on their Overo product for
> many months now.
> 
> Tested-by: Steve Sakoman <steve@sakoman.com>

If there is a concern on OMAP2 support, I can confirm that there is no difference between OMAP2 and OMAP3 Display Subsystem from Register level. So what ever works on OMAP3 DSS2 should straight away work for OMAP2 as well.

I agree with rest of the folks here, we should get DSS2 merged in mainline. It is being extensively used on all OMAP3 platforms.

Regards,
Khasim
