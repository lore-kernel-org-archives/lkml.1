Return-Path: <linux-kernel-owner+w=401wt.eu-S932302AbXE2BwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302AbXE2BwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 21:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbXE2Bv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 21:51:57 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:23428 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbXE2Bv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 21:51:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Ja82ACRu2eoIP3urk3eY1CRAYF14T+3kVeueXUoaVh3WJ9uZ1jowvHUbqzKiH2DteSyMG8qlEG+LEmcvawBMCf/6/Wj3vO7DrsCOSxPFN1erLXaECl0yaPZYW0WOyN4atuhl28BVAnOWtNefSws03VnsD5WZlfc+3PgKNeKEgKE=
Message-ID: <2cd57c900705281851g7e0cdbe8j9db0689390155dd4@mail.gmail.com>
Date: Tue, 29 May 2007 09:51:55 +0800
From: "Qi Yong" <qiyong@fc-cn.com>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: [PATCH] add a trivial patch style checker
Cc: "Andrew Morton" <akpm@osdl.org>, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Joel Schopp" <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <9a1288909c10f2935af82ec5cea0c46b@pinky>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a1288909c10f2935af82ec5cea0c46b@pinky>
X-Google-Sender-Auth: 4106a20b3547d3d3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/05/07, Andy Whitcroft <apw@shadowen.org> wrote:

...

> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
> index a417b25..23637e8 100644
> --- a/Documentation/SubmittingPatches
> +++ b/Documentation/SubmittingPatches
> @@ -118,7 +118,21 @@ then only post say 15 or so at a time and wait for review and integration.
>

...

> -8) Name your kernel version.
> +9) Name your kernel version.
>
>  It is important to note, either in the subject line or in the patch
>  description, the kernel version to which this patch applies.

If omitted, we could assume it default to the latest linus git tree.

> -10) Include PATCH in the subject
> +11) Include PATCH in the subject
>
>  Due to high e-mail traffic to Linus, and to linux-kernel, it is common
>  convention to prefix your subject line with [PATCH].  This lets Linus

or use "patch", to be easier to read.

-- 
Qi Yong
