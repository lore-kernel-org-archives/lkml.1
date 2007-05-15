Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbXEOQNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbXEOQNq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 12:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbXEOQNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 12:13:39 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:12729 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbXEOQNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 12:13:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uRoDelmGz376QS+bUBIAnYTqxNA/GGn+j0KNzwdKTBinesDbIdk1mA+NImqpMo2s1qMAj3qOHg+3AlK41utG8agXK9s64OHyfojJMgyrusuPGFoNbZbLwNO0kELLg6ivN0gPgGlppOQ0YbdBt0WyMXBUGq+du5mQ/vbTmfPRSNs=
Message-ID: <4d8e3fd30705150913g6c870941w50e5567588e81f2d@mail.gmail.com>
Date: Tue, 15 May 2007 18:13:34 +0200
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Brad Campbell" <brad@wasp.net.au>
Subject: Re: Standalone swap prefetch patch for mainline
Cc: "Con Kolivas" <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       ck@vds.kolivas.org
In-Reply-To: <4649D60C.7020101@wasp.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705141210.43614.kernel@kolivas.org>
	 <4649C789.6050305@wasp.net.au>
	 <4d8e3fd30705150818g1755b441w536763d0902ca3cf@mail.gmail.com>
	 <4649D60C.7020101@wasp.net.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/07, Brad Campbell <brad@wasp.net.au> wrote:
> Paolo Ciarrocchi wrote:
>
> > Brad, is it possible for you to do some more test with the latest
> > version of both SD and CFS  and post some more detailed feedbacks?
> > That would help a lot.
>
> Err.. Ok. I have the latest version of SD (that I know about). I could upgrade CFS, but unlike those
> doing real scientific testing, I'm just getting a feel with my usual usage patterns (thunderbird,
> firefox, openoffice, gimp, x-chat and gnome). I don't have any hard fast metrics I can measure
> against really.

I think that just some words about your feeling while you doing your
standard workload would be sufficient.
Latest CFS is here:
http://people.redhat.com/mingo/cfs-scheduler/
and according to your email you already have latest SD.

> Anything I post would be subjective at best. (And to be honest, once I get a stable and usable
> kernel I tend to stick with it for a month or so as I don't reboot - suspend2 regularly goes 100
> suspend/resume cycles to S3 between reboots for me)
>
> I'm a little more willing to experiment on my desktop box, but I really live from the laptop.

Many thanks in advance.

regards,
-- 
Paolo
"Tutto cio' che merita di essere fatto,merita di essere fatto bene"
Philip Stanhope IV conte di Chesterfield
