Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbXI3B0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbXI3B0Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 21:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbXI3B0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 21:26:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:41256 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbXI3B0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 21:26:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=KVDV95q7Gq2vbpOsOl5Y0wEtWBXNOyVgNwG4HwIr2NrzbMhPXl2is9G0Wo2r9Dvpb0K1RIkmpCZc6NYOyS172M1r0eXR9B9lDpOgkM5L+ePTEY9vIzb2GEO1B1JSRV8PVaK7cHlPg1QSSVpmSvwGv42QQkD0ujV/Xk6683Jo/Js=
Message-ID: <75b66ecd0709291826j64c45bcdoc957411f0fb25689@mail.gmail.com>
Date: Sat, 29 Sep 2007 21:26:15 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Florian Schmidt" <mista.tapas@gmx.net>
Subject: Re: getting FUSD compiled with current kernels
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200709291823.35868.mista.tapas@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709291823.35868.mista.tapas@gmx.net>
X-Google-Sender-Auth: 06c2a70a113a7dde
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/29/07, Florian Schmidt <mista.tapas@gmx.net> wrote:
> My goal is to hack up oss2jack [3] to use ALSA pcm devices.. And a later goal
> is to create a virtual ALSA soundcard [which would multiplex access to a real
> non hw-mixing capable soundcard] to finally end the dmix software mixing woes
> linux users have to endure for the last years :)

What problems with ALSA's userspace mixing are you trying to solve?

Lee
