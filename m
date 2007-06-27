Return-Path: <linux-kernel-owner+w=401wt.eu-S1758087AbXF0La5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbXF0La5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 07:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbXF0Lau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 07:30:50 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:17424 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbXF0Lat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 07:30:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HweUnUGfDztJZW7E1YRSnVZY4OkLd/myzkC0fTjVtaoD54tGfhzAQwjSZQ8Z918ep9ohhAYE6OL0lWCj6+7+n0LglNgSKj1w/m9/aUk4yPk7RrfxuQ9lg++dhU0AVMSZkLshnlSBF+vcCTONk0Q0nBspNAk8XSGJNjNhrpKbSkk=
Message-ID: <5d5443650706270430s4c7e97dfxfc375d2ff4e4ce37@mail.gmail.com>
Date: Wed, 27 Jun 2007 17:00:49 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH 02/17] OMAP: Add TI OMAP1610 accelerator entry.
Cc: linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       akpm@linux-foundation.org, "Tony Lindgren" <tony@atomide.com>,
       imre.deak@solidboot.com, juha.yrjola@solidboot.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070626165205.GB22389@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5d5443650706260534k5d6aca34k9f574b6ffddf85b2@mail.gmail.com>
	 <20070626165205.GB22389@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> Your patch ordering is bad.
> Patch 1 uses the symbol: FB_ACCEL_OMAP1610
> but it is defined by patch 2.
>
> Please reorder patches so the module compiles for each
> and every patch being applied.
>
> In this way you do not break git bisect for example.
>

Yes, in this case I will merge 1st and 2nd patch.

-- 
--Trilok Soni
