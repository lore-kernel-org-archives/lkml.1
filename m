Return-Path: <linux-kernel-owner+w=401wt.eu-S1751624AbXCKAom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbXCKAom (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 19:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbXCKAol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 19:44:41 -0500
Received: from wx-out-0506.google.com ([66.249.82.225]:41581 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbXCKAok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 19:44:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=P/MVZHRcK0GMXCGLKWNDO58MgPYYFHHwLn2X915T4H3/8jNTj6xwzSCKbwbrIcVcMWmETleJGUbz/SDmOGvJBJUbbc+KsNy6tAhbvaeLMjVZlU0Ptp4vYIYQXzf8/if4nCQ3qgrofFAMuZ0LVV1+PNlZ6STk4C23soVe8sKNvc4=
Message-ID: <7d01f9f00703101644m6f24af63l65c267221140cab0@mail.gmail.com>
Date: Sun, 11 Mar 2007 01:44:39 +0100
From: "Thibaut VARENE" <T-Bone@parisc-linux.org>
To: "Con Kolivas" <kernel@kolivas.org>
Subject: Re: [ck] Re: RSDL v0.28 for 2.6.20
Cc: "ck list" <ck@vds.kolivas.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <7d01f9f00703101643u572035fcp9185ab43e82b20d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703101845.59497.kernel@kolivas.org>
	 <45F2F45F.6000403@seclark.us> <20070310191118.GL943@1wt.eu>
	 <200703111054.42921.kernel@kolivas.org>
	 <7d01f9f00703101643u572035fcp9185ab43e82b20d2@mail.gmail.com>
X-Google-Sender-Auth: 304240acf98bd00b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/11/07, Thibaut VARENE <T-Bone@parisc-linux.org> wrote:
> On 3/11/07, Con Kolivas <kernel@kolivas.org> wrote:
>
> > Has anyone had any trouble with RSDL on the stable kernels (ie not -mm)?
>
> Tested fine so far on ppc, ia64 and (mostly) parisc.

I meant ppc64, actually.
Gomen.

-- 
Thibaut VARENE
http://www.parisc-linux.org/~varenet/
