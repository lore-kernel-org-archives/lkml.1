Return-Path: <linux-kernel-owner+w=401wt.eu-S1754899AbXFNElR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbXFNElR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 00:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbXFNElD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 00:41:03 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:39400 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbXFNElA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 00:41:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Kvft4VLDFjelmAPcIHCSO8+GeFmPXgZSEEj/9rdIwVbXasf88zhOilsx9DZBtEag+jZ6cbrYpFU7Sih9rCvWBf+1OddQLkV1/TBt+qKjgoJJppK6tAYgOBUnLwSmfcL0Y8p1m6G/IaFiFa9PgOFjdRVsss1SlceGR9IDkw6N9Xc=
Message-ID: <21d7e9970706132140v2b357332k5a14da05ab6257b1@mail.gmail.com>
Date: Thu, 14 Jun 2007 14:40:59 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Carlo Wood" <carlo@alinoe.com>, "Dave Airlie" <airlied@gmail.com>,
       "Dave Jones" <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: DRI/AGP on AMD64 based machine
In-Reply-To: <20070614043611.GA21002@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1181721735.4418.10.camel@malory>
	 <20070613162925.GG3875@redhat.com> <20070614011506.GA30566@alinoe.com>
	 <21d7e9970706131817t40ca2d77w658e2540dc3ee7c4@mail.gmail.com>
	 <20070614043611.GA21002@alinoe.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/07, Carlo Wood <carlo@alinoe.com> wrote:
> On Thu, Jun 14, 2007 at 11:17:50AM +1000, Dave Airlie wrote:
> > How do you have a 965G in an amd64 box? does not compute.
>
> Why not?  It's the ASUS P5B Deluxe motherboard with an
> Intel P965/ICH8R chipset. The cpu is a QX6700 2.66 GHz,
> that's an Intel Core 2 Quad Extreme.
>
> amd64 is just the architecture, not the brand. It's an
> all intel machine, if that's what you mean.
>

x86-64 is an architecture, amd64 is used by some people however in
your case agp-amd64 is not what you wanted, you have a problem with
intel-agp.c then.. which is different than what started this thread..

Dave.
