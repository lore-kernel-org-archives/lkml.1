Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbXEYW4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbXEYW4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 18:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbXEYW4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 18:56:48 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:33700 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbXEYW4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 18:56:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R4w7A3shYd2v25TBs/cdCNNhgL9PIhEX9ljvkP46zrtjfIn2C5N1dl/1pQgaQTwRMDrC/yOJXK23py08G/7xPxtSxEZxITDWjMMHtXsVSZG4tuQ59b1xOSBBXvjz5G7wRUh809pGDSlkZWkY33NDdOJrkuEWxC9CPmfyC/G4yks=
Message-ID: <a781481a0705251556o28c9745dr8b77f8cf3e03f8ba@mail.gmail.com>
Date: Sat, 26 May 2007 04:26:46 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] MIPS: Transform old-style macros to newer "__noreturn" standard.
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ralf Baechle" <ralf@linux-mips.org>
In-Reply-To: <46576752.4090607@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705251418050.13623@localhost.localdomain>
	 <46572DAF.1000108@zytor.com>
	 <Pine.LNX.4.64.0705251458440.13906@localhost.localdomain>
	 <46573B23.1090700@zytor.com>
	 <Pine.LNX.4.64.0705251705510.14578@localhost.localdomain>
	 <4657589F.7050509@zytor.com>
	 <a781481a0705251516l5de0e95ayae45f7a65e25c8cf@mail.gmail.com>
	 <4657626B.7010204@zytor.com>
	 <a781481a0705251535g27bd38a5s496cc7b44f2d45d5@mail.gmail.com>
	 <46576752.4090607@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Satyam Sharma wrote:
> >>
> >> Sorry to say, but weren't you the person who didn't recognize !! as the
> >> idiomatic booleanizing operator?
> >
> > Yes, of course, please prove a link / connection between that and this?
> >
>
> Very simple: it shows a lack of understanding of idiomatic use of C.

Ah, I could lecture / *prove* to you how this argument ad hominem is
*absolutely* fallacious and nonsense, but I'll leave that just now.
