Return-Path: <linux-kernel-owner+w=401wt.eu-S1422828AbXBPASy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422828AbXBPASy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 19:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422829AbXBPASy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 19:18:54 -0500
Received: from wr-out-0506.google.com ([64.233.184.235]:39479 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422828AbXBPASx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 19:18:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nrUwDEYs3GkeFb6LC53Zkhb8VW7wtElIg2teLNvimLtkQY/Jxf/beSj6lArWYUKwGg9XUnNDdG5YOlOul94BmpSsvHtT3z0SF4FTMhfxj0NbxJFlWCwSMhpwYVwaDc8wefzZ2gRF5UDyNtEYJIgicn9Ww+nMoMgfkQTXHzALXok=
Message-ID: <75b66ecd0702151618g752dcd10p99b17ad20a81569c@mail.gmail.com>
Date: Thu, 15 Feb 2007 19:18:52 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Greg Trounson" <gregt@maths.otago.ac.nz>
Subject: Re: GPL vs non-GPL device drivers
Cc: "Theodore Tso" <tytso@mit.edu>, linux-kernel@vger.kernel.org
In-Reply-To: <45D4F67D.4030902@maths.otago.ac.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
	 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
	 <20070215061149.GE15654@redhat.com>
	 <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com>
	 <20070215165339.GB5285@thunk.org> <45D4F67D.4030902@maths.otago.ac.nz>
X-Google-Sender-Auth: 007b4cddf472ac3c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/07, Greg Trounson <gregt@maths.otago.ac.nz> wrote:
> Theodore Tso wrote:
> > On Wed, Feb 14, 2007 at 10:27:10PM -0800, v j wrote:
> >> You are right. I have not contributed anything to Linux. Except one
> >> small patch to the MTD code. However, I don't think that is the point
> >> here. I am perfectly willing to live with the way Linux is today. I am
> >> telling you as a user that if Linux continues on the current path it
> >> will become less and less attractive to Embedded Users.
> >
> > But so what?  How will that hurt *Linux*?  If the Embedded developers
> > don't contribute changes back, it doesn't hurt us any if they go away
> > and start paying $$$ to VxWorks instead of using Linux for free.
>
> I disagree.  Linux needs popularity at the moment.

Um... what's your point?  Allowing vendors to legally ship embedded
devices containing proprietary drivers would require relicensing the
kernel which is impossible, for reasons that have been discussed at
length on this list.

Lee
