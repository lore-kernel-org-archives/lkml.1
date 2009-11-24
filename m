Return-Path: <linux-kernel-owner+w=401wt.eu-S1755692AbZKXGAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692AbZKXGAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 01:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbZKXGAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 01:00:47 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:42748 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbZKXGAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 01:00:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KS6003yrAyeMHmisG4OboVSMq36ZTcByDqc359xZ4PpRQYSbmfNHtI2CeKmMx/8JWy
         DJf8LhvYp5JBMwpiw4RsmZwld+sSwx8ztNIiTanaEnFBYXvfckCPadDs5PulHP7Ac8rB
         Om4hoq4kFT/2XUSjVOJRBxTt6Z+6sPsakxV9s=
MIME-Version: 1.0
In-Reply-To: <200911240456.nAO4uAlB002080@deneb.dwf.com>
References: <200911240456.nAO4uAlB002080@deneb.dwf.com>
Date: Tue, 24 Nov 2009 14:00:52 +0800
Message-ID: <2375c9f90911232200m475cc2b2v9cfd355591ba2153@mail.gmail.com>
Subject: Re: Kernel options.
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Reg Clemens <reg@dwf.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 12:56 PM, Reg Clemens <reg@dwf.com> wrote:
> I have a pre-compiled 64bit kernel from Fedora11, and I can execute
> both 32 and 64bit executables with it.
>
> I have just built a new kernel (to test some PPS code), and I CANT
> execute 32bit executables with it.
>
> There must be some option I didnt check.
> What is it?????

I am assuming you are using an Intel processor, have you enabled
CONFIG_IA32_EMULATION?
