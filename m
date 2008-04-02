Return-Path: <linux-kernel-owner+w=401wt.eu-S1757804AbYDBPGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804AbYDBPGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 11:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754971AbYDBPG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 11:06:27 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:41333 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbYDBPGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 11:06:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IJ3vFGXYmEz2m6eqEM3kiSzDHYYI4Xp5CNp9oFNa7uBTUcRUxSiGdHHWDJNdkeEKIIU4Jd2kd2bQI23aAQyZzxpnqPvNKKYT1fFpBPQOIjefvQpZkbCrpHlr0htbDS51a7VH208ebBM/aFTyw8m5Ieonb4lKX72u9c0V+KeIbsE=
Message-ID: <bc64b4640804020806y2dc68600k8179092c9c4a100e@mail.gmail.com>
Date: Wed, 2 Apr 2008 19:06:24 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] Fix tosakbd suspend
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080402104921.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080401144224.GA6436@USFSHXP-002051>
	 <20080402141632.GA19698@doriath.ww600.siemens.net>
	 <bc64b4640804020738l25b51263la04cff12c38e0325@mail.gmail.com>
	 <20080402104921.ZZRA012@mailhub.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/4/2, Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> On Wed, Apr 02, 2008 at 06:38:26PM +0400, Dmitry wrote:
>  > Hi,
>  >
>  > Sorry, that was me... Sometimes I hate git-am & git-format-patch
>  >
>
>
> Heh, you had me scratching my head for a moment ;)

:)

>
>  > 2008/4/2, <dbaryshkov@gmail.com>:
>
> > >
>  > > Fixed two minor glitches. Works for me. Please add it to your tree.
>  > >
>
>
> What were they? I dont see any difference from the patch I sent to you,
>  so I want to make sure I have the correct version.

suspended instead of suspeneded in struct tosakbd definition,
declaration of tosakbd in tosakbd_resume.

-- 
With best wishes
Dmitry
