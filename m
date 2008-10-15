Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbYJOVeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbYJOVeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYJOVeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:34:36 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:21964 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753427AbYJOVeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:34:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mgrXHnfegGiOME1hosRCOP2VfXJebrqYq1kApHSsxFshmpQOvO7HSUikDytgSQPy1HTy3E8H8vybQQ52V6HF+3nhgdqd41CWyOLnexyaKyZceHXbjDC/Pzzn8yRasf+KQG37RO3y3H3zWMHrYHfEG1vtQ8p7gZ2ONC5f1JmaHik=  ;
X-YMail-OSG: ri7K5u0VM1m6jScxCeao2ecUt8vp7t_1Fzj0V6CYJLfNkDZTLaPJVH2WMeB8bUwstno_eWCYgjTfkBkzy8iR1fedEA27zjS3fCfGEfkrg4GrdyHVkdOJsdbv9hOfuM7.6tAsQJFx3Q3kC38Q74VdRJB7zBefu2LHfyeVFXYHBpq2jP5st_HNzqoveZm1
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH 6/9] mpc52xx_psc_spi: remove code associated with !CONFIG_PPC_MERGE
Date: Wed, 15 Oct 2008 14:34:33 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       akpm@linux-foundation.org
References: <1219294018-12557-1-git-send-email-galak@kernel.crashing.org> <1219294018-12557-7-git-send-email-galak@kernel.crashing.org> <764B32F3-E12E-4649-A2BB-3F94044D371F@kernel.crashing.org>
In-Reply-To: <764B32F3-E12E-4649-A2BB-3F94044D371F@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810151434.33693.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 October 2008, Kumar Gala wrote:
> 
> On Aug 20, 2008, at 11:46 PM, Kumar Gala wrote:
> 
> > Now that arch/ppc is gone we don't need CONFIG_PPC_MERGE anymore
> > remove the dead code associated with !CONFIG_PPC_MERGE.
> >
> > Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> > ---
> > drivers/spi/mpc52xx_psc_spi.c |   55  
> > -----------------------------------------
> > 1 files changed, 0 insertions(+), 55 deletions(-)
> 
> Any update on acceptance of this patch?

Still seems to be in the MM queue ready to merge
a bit later in the window.

- Dave

