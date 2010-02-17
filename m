Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab0BQSvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 13:51:18 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:45527 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751408Ab0BQSvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 13:51:17 -0500
Date: Wed, 17 Feb 2010 13:51:05 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: david@lang.hm
Cc: Volker Armin Hemmann <volkerarmin@googlemail.com>,
       Kyle Moffett <kyle@moffetthome.net>,
       Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
       Neil Brown <neilb@suse.de>,
       "Mr. James W. Laferriere" <babydr@baby-dragons.com>,
       Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: Linux mdadm superblock question.
Message-ID: <20100217185105.GA15614@emergent.ellipticsemi.com>
Mail-Followup-To: david@lang.hm,
	Volker Armin Hemmann <volkerarmin@googlemail.com>,
	Kyle Moffett <kyle@moffetthome.net>,
	Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
	Neil Brown <neilb@suse.de>,
	"Mr. James W. Laferriere" <babydr@baby-dragons.com>,
	Bill Davidsen <davidsen@tmr.com>,
	Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org
References: <201002140251.59668.volkerarmin@googlemail.com>
 <alpine.DEB.2.00.1002170932010.4721@asgard.lang.hm>
 <20100217181016.GA14983@emergent.ellipticsemi.com>
 <201002171927.07051.volkerarmin@googlemail.com>
 <20100217183703.GA15446@emergent.ellipticsemi.com>
 <alpine.DEB.2.00.1002171040350.4721@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002171040350.4721@asgard.lang.hm>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:41 Wed 17 Feb     , david@lang.hm wrote:
> On Wed, 17 Feb 2010, Nick Bowler wrote:
> > It takes about half a second for mdadm to assemble my root array, is
> > that what you're referring to?
> >
> > I assume that kernel auto-assembly is no faster, although I've never
> > used it.  Regardless, half a second isn't very long to wait.
> 
> If you are aiming for a 5-second boot time it's 10% of your total boot 
> time. That's a lot for a feature that's not needed.

Only if the kernel auto-assembly takes zero time, which it obviously
does not.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
