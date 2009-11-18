Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbZKRKNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbZKRKNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 05:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752973AbZKRKNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 05:13:06 -0500
Received: from elettra.colt-to.towertech.it ([213.215.222.70]:49397 "EHLO
	elettra.colt-to.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752057AbZKRKNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 05:13:06 -0500
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Nov 2009 05:13:05 EST
Date: Wed, 18 Nov 2009 11:06:43 +0100
From: Alessandro Zummo <azummo-lists@towertech.it>
To: rtc-linux@googlegroups.com
Cc: error27@gmail.com, balajirrao@openmoko.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [rtc-linux] [patch] rtc: use after free in pcf50633_rtc_probe()
Message-ID: <20091118110643.122e8dd1@linux.lan.towertech.it>
In-Reply-To: <alpine.DEB.2.00.0911161312140.12810@bicker>
References: <alpine.DEB.2.00.0911161312140.12810@bicker>
Organization: Tower Technologies
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Nov 2009 10:30:14 +0200 (SAST)
Dan Carpenter <error27@gmail.com> wrote:

> "rtc" is freed and then dereferenced on the next line.  This patch fixes 
> that.
> 
> This is a resend.  I have been offline for the last few months so I may 
> have missed a reply or something.  Not sure what the status was.
> 
> regards,
> dan carpenter
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>


 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

