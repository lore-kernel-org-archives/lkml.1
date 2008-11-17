Return-Path: <linux-kernel-owner+w=401wt.eu-S1752676AbYKQNdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbYKQNdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbYKQNd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:33:27 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:14341 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbYKQNd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:33:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Z+0KMjRKRajHskSZu8JVLEdeM9e9gfzRLWzGyoTwclYMQDEGdAc7Is8b2QSd+2XZoy
         df6eG05kxjj7uJ/eIgXFx2M+8D2Q/XhpcxaATrJU+jcXsDfFJk1c8vIhuwoy7GktB2PI
         mu7N7UOB9MPNhCNyckIZ8CKMCEWQ+mGNlHOSo=
Message-ID: <3aaafc130811170533j4c7e0008vd76c42da0cbb9f36@mail.gmail.com>
Date: Mon, 17 Nov 2008 08:33:25 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Victoria Muntean" <vikimun@gmail.com>
Subject: Re: size of swapped-out part of the process
Cc: "Kernel Linux" <linux-kernel@vger.kernel.org>
In-Reply-To: <ab4346860811170453i2bba95a6nb16c2c9e59424272@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ab4346860811170452t2cbcb451u407edca19c9e0ba6@mail.gmail.com>
	 <ab4346860811170453i2bba95a6nb16c2c9e59424272@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2008 at 7:53 AM, Victoria Muntean <vikimun@gmail.com> wrote:
> How can I calculate size of swapped-out part of the process from
> /proc/PID/*, even if approximately ?
> For example, I have VmSize=1216192 kB, VmRSS = 628788 kB, but global
> swap-in-use==0.
> Hence (VmSize - VmRSS) is far from being swapped-out part of the
> process. What is ?

Doesn't top's SWAP field give you this?

>
> Thanks
> Viki
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
