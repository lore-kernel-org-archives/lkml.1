Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbXHBBXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbXHBBXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 21:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754136AbXHBBXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 21:23:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:39570 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbXHBBXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 21:23:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nS7OJwvP6dxSVRf216Yfc5yfW33OE0deoLXn+H6G8+ula5bwfN/BzuobPzoewlz3/WNP10mB/Dz4fzNvbNrD8FJ9FeXbfISC4u8iv5XUUSnNAIQoKPOfgAANvx3llYUlMiGLH25MJKgbNFaQKdOZ3tpYDvAeZE5NKjxLrpJidoc=
Message-ID: <75b66ecd0708011822n5724220ifc59d5f9c75b3661@mail.gmail.com>
Date: Wed, 1 Aug 2007 21:22:57 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: bamakhrama@gmail.com
Subject: Re: Profiling the Kernel
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <40378e40708010851q48d73e36v3b1d468aa7712284@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <40378e40708010851q48d73e36v3b1d468aa7712284@mail.gmail.com>
X-Google-Sender-Auth: 5e9358f1012eb781
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/07, Mohamed Bamakhrama <bamakhrama@gmail.com> wrote:
> Hi *,
> I have a question regarding profiling the Linux kernel code during
> runtime (by "profile", I mean the usage of each function/module within
> the kernel itself). I googled and found many "system-wide" profiler
> such as sysprof, Oprofile, etc... I am working on an embedded system
> project and currently we are using an on-chip debugger which
> interfaces with the system through EJTAG port. All what it can provide
> is just a "uniform sampling" of the kernel code usage and according to
> the manufacturer, it is not a safe way to determine the "hot spots"
> within the kernel. Does anyone know about any hardware/software tool
> that can provide a "good" profile of the kernel code usage?

Oprofile can do what you want, check the docs and google.

Lee
