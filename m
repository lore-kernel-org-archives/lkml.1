Return-Path: <linux-kernel-owner+w=401wt.eu-S1764686AbYCDSDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764686AbYCDSDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759067AbYCDSCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:02:54 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:50012 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758860AbYCDSCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:02:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MiGbgkVc8nyoHHCrWp1YBM6MuiQncKlDHNR0nhV7K9K5nWbdT/AevYQMiP5L65uVsPXyI3XprmLsccgN1Jy1uoaSFsb1wlm85apDyQgijhh2vwIdO9XC6N7D8Mi4jOeCAGK1J0Bvtz8V7P1Nrk0qz5TKfGqk9mNgQiDnDbwhxaA=
Message-ID: <a728f9f90803041002r63322f82q60b26eb9d52e8dc1@mail.gmail.com>
Date: Tue, 4 Mar 2008 13:02:51 -0500
From: "Alex Deucher" <alexdeucher@gmail.com>
To: "JoJo jojo" <onetwojojo@gmail.com>
Subject: Re: 2.6.25-rc3 + RS690 + DRM + xf86-video-ati hang
Cc: "Dave Airlie" <airlied@linux.ie>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jonathan McDowell" <noodles@earth.li>, xorg-driver-ati@lists.x.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <226dee610803040913h4718b61r4310fa78938bc386@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080301193511.GP9009@earth.li>
	 <20080303224830.28e98b2b.akpm@linux-foundation.org>
	 <alpine.DEB.0.82.0803040816180.24971@skynet.skynet.ie>
	 <20080304085155.GX9009@earth.li>
	 <alpine.DEB.0.82.0803041120400.24971@skynet.skynet.ie>
	 <226dee610803040913h4718b61r4310fa78938bc386@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 4, 2008 at 12:13 PM, JoJo jojo <onetwojojo@gmail.com> wrote:
> Is 128 MB some sort of a sweet spot for ram allocated to gpu  ?
>  (hard coded?)
>
>  First Alex suggested that, & now you.
>
>  (asking 'coz i used 256 MB while testing)

It shouldn't really matter, it's just that the "auto" setting seems to
causes hangs for some people.

Alex
