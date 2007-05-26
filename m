Return-Path: <linux-kernel-owner+w=401wt.eu-S1752149AbXEZWgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbXEZWgA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 18:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750916AbXEZWfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 18:35:52 -0400
Received: from wx-out-0506.google.com ([66.249.82.226]:48812 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbXEZWfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 18:35:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BA662zT2mWKRCeZJSw3isLFTY4fwGzThyJP/H6rW7CzxpV8E6erV2uZg/+8MDmPoLvqUhNZEYfEpQJQ5i0swE8ht/l4rJwK53JdjZOhl8kN9RJ370WATZHalyL4fr/x+gL4wU71+Z3O4QOh16itvLC40AwOgBoYWSIpjICd22h8=
Message-ID: <7b69d1470705261535i207d55cei75c870cf3f86a459@mail.gmail.com>
Date: Sat, 26 May 2007 15:35:51 -0700
From: "Scott Preece" <sepreece@gmail.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] [condingstyle] Add chapter on tests
Cc: "Auke Kok" <auke-jan.h.kok@intel.com>, randy.dunlap@oracle.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0705262213000.7344@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070525172509.5138.56430.stgit@localhost.localdomain>
	 <20070525172515.5138.13652.stgit@localhost.localdomain>
	 <Pine.LNX.4.61.0705262121150.7344@yvahk01.tjqt.qr>
	 <Pine.LNX.4.61.0705262213000.7344@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
>
> Based in part on Auke's patch.
>
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
>
> ---
>  Documentation/CodingStyle |   74 +++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 64 insertions(+), 10 deletions(-)
>
> Index: linux-2.6.22-rc3/Documentation/CodingStyle
> ===================================================================
> --- linux-2.6.22-rc3.orig/Documentation/CodingStyle
> +++ linux-2.6.22-rc3/Documentation/CodingStyle
> @@ -407,7 +407,61 @@ out:
>         return result;
>  }
>
> -               Chapter 8: Commenting
> +               Chapyer 8: Tests
---

Fix the "Chapyer" spelling above.

However, I think this set of rules is not universally agreed to and
probably should not be added at this time. I'm not convinced that it
makes the code more readable.

scott
