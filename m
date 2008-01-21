Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYAUShd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYAUShd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 13:37:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYAUShZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 13:37:25 -0500
Received: from wx-out-0506.google.com ([66.249.82.234]:1254 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbYAUShY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 13:37:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=fXC78xNbVx+8zj2Y63fnj9go6mQxoobiGD65NxjJoCoEeX8hYyjCLh3UQifVU7QW2gc9GBCD22Kx3ARezbrjRbcX/aEhiz75lpM10J63harymGkpGrkvULzqNoBpTfbc3O3ew3Ld58b7l8SBdUrgsIFlpdsqJucY+JHIogmz+ew=
Message-ID: <31e679430801211037j6b7f06bdr5d36c39f79c337ab@mail.gmail.com>
Date: Mon, 21 Jan 2008 20:37:20 +0200
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH 1/2] I2C: ISP1301_OMAP: New-style i2c driver updates, part 1
Cc: "Felipe Balbi" <me@felipebalbi.com>, linux-kernel@vger.kernel.org,
       david-b@pacbell.net, tony@atomide.com, "Linux I2C" <i2c@lm-sensors.org>
In-Reply-To: <20080121181500.48b3a3d2@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1199379597-6273-1-git-send-email-me@felipebalbi.com>
	 <1199379597-6273-2-git-send-email-me@felipebalbi.com>
	 <20080121181500.48b3a3d2@hyperion.delvare>
X-Google-Sender-Auth: 7b7698035733c8f3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 21, 2008 7:15 PM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Felipe,
>
> On Thu,  3 Jan 2008 11:59:56 -0500, Felipe Balbi wrote:
> > Based on David Brownell's patch for tps65010, this patch
> > starts converting isp1301_omap.c to new-style i2c driver.
> >
> > Signed-off-by: Felipe Balbi <me@felipebalbi.com>
> > ---
> >  drivers/i2c/chips/isp1301_omap.c |   60 +++++++++++++++++++------------------
> >  1 files changed, 31 insertions(+), 29 deletions(-)
> >
>
> Next time, please send this patch to the i2c mailing list instead of
> LKML if you want to get some attention.

Ok, i'll do it.
Sorry for missing i2c mailing list.

-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
