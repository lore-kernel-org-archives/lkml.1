Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbXH3DwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbXH3DwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 23:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbXH3DwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 23:52:11 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:35090 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbXH3DwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 23:52:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rjDQgno/i5CK7SSwwpByee+dhwwFPp0z4z589EM2qpVfn+gEC/8u87ZaTV6xODShQwsQMmKURCkn0I9R6W/wkEsLJ6X+xdmX95RH07tsiTLPU0pOEWmnOIWSaVINwDSs5T/xCwStuEVep03k5F8YN4aY35DSYAGW/B27OvRolco=
Message-ID: <47f5dce30708292052v473336a1kbc386787debcbccd@mail.gmail.com>
Date: Wed, 29 Aug 2007 23:52:08 -0400
From: "Jaya Kumar" <jayakumar.alsa@gmail.com>
To: "Andres Salomon" <dilinger@queued.net>
Subject: Re: [PATCH 0/5] ALSA: cs5535audio fixes
Cc: akpm@linux-foundation.org, jordan.crouse@amd.com,
       linux-kernel@vger.kernel.org, info-linux@geode.amd.com
In-Reply-To: <20070829232745.5ea9ff3e.dilinger@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070829232745.5ea9ff3e.dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/29/07, Andres Salomon <dilinger@queued.net> wrote:
> Hi,
>
> Here are a bunch of fixes for the cs5535audio driver.  None of these are
> OLPC specific; generic chip and power management fixes, and one cleanup
> patch.  All have been tested on an OLPC (5536), so even though the 5535
> data sheet claims to be the same, it would be nice to hear success/failure
> reports from someone with a 5535.

The patches look good. I'm traveling till Sep 2nd so can't test on
5535 yet. Thanks very much for your efforts Andres.

Thanks,
jaya

Acked-by: Jaya Kumar <jayakumar.alsa@gmail.com>
