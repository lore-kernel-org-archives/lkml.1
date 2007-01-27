Return-Path: <linux-kernel-owner+w=401wt.eu-S1751840AbXA0US2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbXA0US2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 15:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbXA0US2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 15:18:28 -0500
Received: from wx-out-0506.google.com ([66.249.82.226]:20538 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbXA0US1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 15:18:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=mSCOnIp4UrgonZXDyMyEOWg1FIEXwhYdy7eya7pCg3loIols/lNlSP6DiRmNndM2kKHOOc3BzkRCaLIjWU+DL5s4GOzzEqGXQ8ipcoBI55jZlRAd6J8sj9CN17KLKL1XeQ/uY2wSUKdrqNM5o/YHIoeZ0O9gJjiILp5gXkIqIRQ=
Message-ID: <75b66ecd0701271218q428e958cvc8cda7c356c315e3@mail.gmail.com>
Date: Sat, 27 Jan 2007 15:18:27 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Gianluca Alberici" <gianluca@abinetworks.biz>
Subject: Re: Nozmi status ?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45BB3FFF.1090806@abinetworks.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45BB3FFF.1090806@abinetworks.biz>
X-Google-Sender-Auth: 42805d2fd1cebd9f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/27/07, Gianluca Alberici <gianluca@abinetworks.biz> wrote:
> Hello,
>
> What is the status of the HSDPA driver after 2.6.19.1 ? Is it part of
> the kernel tree or not yet ?
> If not is there any version of ther nozomi pack which is gonna compile
> under ker > 2.6.18 (the original one is not compiling anymore after 2.6.18).

It's up to the vendor to fix the driver to work with newer kernels
and/or submit the driver for inclusion in the kernel.  Do you know
whether they've done that?

Right now it's impossible to even review the driver because the
sources are only available as attachments to forum posts that require
registration to read.

Lee
