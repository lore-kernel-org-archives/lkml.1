Return-Path: <linux-kernel-owner+w=401wt.eu-S936468AbXEVPey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936468AbXEVPey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935480AbXEVPYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:24:23 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:57486 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935268AbXEVPYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:24:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OKRGf8G6Xm0PDZNiSSMsJIQhYv/MADbTsrqJwW2dIdunHQGgf/PTvBJnWX9ewMZktaR1VY0D4nkTKQct9lXwi5/1HHzcpDew6sXCxtednGluvqICrqfPUtT65H768m6ri1+O61KcA7OSirYEOFoik29jZAJaoYlqWoIJmYCvMhc=
Message-ID: <a781481a0705220824j435c10eaj8406f40018a5da1@mail.gmail.com>
Date: Tue, 22 May 2007 20:54:18 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Krzysztof Halasa" <khc@pm.waw.pl>
Subject: Re: any value to "NORET_TYPE" macro?
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       "John Anthony Kazos Jr." <jakj@j-a-k-j.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <m3tzu4kjg8.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain>
	 <alpine.DEB.0.99.0705220950160.3308@sigma.j-a-k-j.com>
	 <Pine.LNX.4.64.0705220959310.14408@localhost.localdomain>
	 <a781481a0705220709s40b80208h47f1f2f7c00a684d@mail.gmail.com>
	 <a781481a0705220716l799ee2efm268deefc40993875@mail.gmail.com>
	 <m3tzu4kjg8.fsf@maximus.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/07, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> "Satyam Sharma" <satyam.sharma@gmail.com> writes:
>
> > But of course, John is *bang right* that if /**/ makes gcc do (or not do)
> > _anything at all_ (be it crying out a warning), then someone surely
> > deserves to get his head bashed in ... :-)
>
> I think it's impossible, comments are removed by preprocessor.

Right -- was just trying to imagine "hard" why that macro existed.
Rday, kill it off!
