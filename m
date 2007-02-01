Return-Path: <linux-kernel-owner+w=401wt.eu-S932769AbXBAWaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769AbXBAWaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 17:30:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932801AbXBAWaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 17:30:05 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:14852 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769AbXBAWaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 17:30:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CbQ5/XSiHtZoaDV7euI5gm0KvgySE6SCi02C452n+eT9lMa8Nylk1O5k5DlG7Idyr9PDKJfRpM6etOUpbwm14rOVxB7T1Y8LxpI1y6KTjEejVFLpCOKoqWRWx1zmUCNxR45Aok377HM62ahCJYpbrw3jcViRdU3F5UIYTbRSpSs=
Message-ID: <3d57814d0702011430l43c03ae1uc950339b6700f859@mail.gmail.com>
Date: Fri, 2 Feb 2007 08:30:01 +1000
From: "Trent Waddington" <trent.waddington@gmail.com>
To: "Jon Masters" <jonathan@jonmasters.org>
Subject: Re: [PATCH] Ban module license tag string termination trick
Cc: "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>,
       "Alexey Dobriyan" <adobriyan@gmail.com>
In-Reply-To: <45C2670F.5000003@jonmasters.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.61.0611011204140.23977@yvahk01.tjqt.qr>
	 <Pine.LNX.4.61.0702012147470.1862@yvahk01.tjqt.qr>
	 <45C2670F.5000003@jonmasters.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/2/07, Jon Masters <jonathan@jonmasters.org> wrote:
> Ok. I totally dig the *idea* here - I mean, this issue has been ongoing
> for a long time now. But I'd like to see a few comments as to whether we
> need a technological mechanism here to enforce the obvious. To me, it
> just seems totally obvious (any legal comment?) that early C string
> termination is undermining the intent of the MODULE_LICENSE tag.

I'm not a lawyer, but I can tell you exactly what a lawyer would say:

  "well, ya know, it's hard to say when it comes to these issues"

that's the answer to *any* copyright question.  :)

Trent
