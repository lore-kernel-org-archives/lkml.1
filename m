Return-Path: <linux-kernel-owner+w=401wt.eu-S933905AbXGZUBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933905AbXGZUBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936130AbXGZT7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 15:59:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:63978 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933397AbXGZT7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 15:59:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=eV6grHR4FvhO2CN07q2oAAFlq2+fPcRBI392hSAPZ7d4JSbTsRm51HIJrKcyVeB99UIlFHNRa2LKNm40KWJGWzpBrOyUdTt54OAX1wXLOUlb+xPMIdEY82cC+ykI6ro5Jw4GrlThLNZHR1ENckBN1oyy2kt1Y2jwh8Y7SPgzlyI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/2] [IDE] Platform IDE driver (was: MMIO IDE driver)
Date: Thu, 26 Jul 2007 21:28:18 +0200
User-Agent: KMail/1.9.6
Cc: Vitaly Bordug <vitb@kernel.crashing.org>, linux-ide@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <20070725165318.5331.23795.stgit@localhost.localdomain> <20070725184312.44ca7a8c@the-village.bc.nu>
In-Reply-To: <20070725184312.44ca7a8c@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707262128.18720.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 July 2007, Alan Cox wrote:
> > pata_platform and ide_platform are carrying same driver names,
> > to easily switch between these drivers, without need to touch
> > platform code.
> > 
> > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> > Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>
> 
> Acked-by: Alan Cox <alan@redhat.com>

added
