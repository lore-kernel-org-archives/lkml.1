Return-Path: <linux-kernel-owner+w=401wt.eu-S1752690AbZICNO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbZICNO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbZICNOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:14:25 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:47825 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbZICNOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:14:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=uyTdIvF++mJgwIDyJuiYnX6Mps7G1PIbmJF5FW03yyDluy9wsSS9Ml+125lgRAuVjd
         I67ICld+tueTePeigJUhulCeraUKWxl17QSQwPYaSmxclYo7mzL6HSNVrW1YeBODvkhM
         3Kn+MGUL+Zq30yiTKyzl+Uwl/izZzVLcnVTKE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Staging tree status for the .32 kernel merge
Date: Thu, 3 Sep 2009 15:14:53 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-00015-gadda766-dirty; KDE/4.3.0; i686; ; )
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
References: <20090903041429.GA29875@kroah.com> <1251967786.3336.19.camel@johannes.local>
In-Reply-To: <1251967786.3336.19.camel@johannes.local>
MIME-Version: 1.0
Message-Id: <200909031514.53355.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 September 2009 10:49:46 Johannes Berg wrote:
> Hi Greg,
> 
> > 	- rt* wireless drivers.  Bart has done amazing work merging all
> > 	  of these together into something much better than they
> > 	  originally were.  And even better, they still work!   Great
> > 	  job Bart!
> 
> Work on the rt2x00 project has also progressed to a point where the
> drivers are getting much closer to being useful, so eventually all this
> work will have been in vain.

The end goal of this work has always been having native rt2x00 support
for all those chipsets (as have been explained multiple times).  If this
means that one day we will delete all Ralink drivers in staging in favor
of proper wireless drivers -- fine with me.

In the meantime (before clean and proper support becomes useful) Linux
users are provided with the possibility to use their hardware before it
becomes obsolete.
