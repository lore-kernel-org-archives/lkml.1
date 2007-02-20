Return-Path: <linux-kernel-owner+w=401wt.eu-S965833AbXBTAyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965833AbXBTAyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965834AbXBTAyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:54:18 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:13874 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965833AbXBTAyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:54:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JFhrSff3KtEyohC2Vysy66QxrAOu3eQQmNGBF3PxO1XuS28ViuCuJJJPPQa3WlSaCnrFWIhjbRpgg9u6NaNqxvq+SKC5Vx8Adf7p7W07GrULiT7qglIYcJZG8JO+2py07FnlTPfy5PxSt6kjQ8ma0wJ388kiv42Q2KmEPzKdnVk=
Message-ID: <a4e6962a0702191654p75df1550he8acce8a0abd29de@mail.gmail.com>
Date: Mon, 19 Feb 2007 18:54:15 -0600
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [-mm patch] fs/9p/vfs_addr.c: make 2 functions static
Cc: "Andrew Morton" <akpm@linux-foundation.org>, rminnich@lanl.gov,
       lucho@ionkov.net, linux-kernel@vger.kernel.org,
       v9fs-developer@lists.sourceforge.net
In-Reply-To: <20070220000734.GX13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
	 <20070220000734.GX13958@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/19/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Sat, Feb 17, 2007 at 09:51:46PM -0800, Andrew Morton wrote:
> >...
> > Changes since 2.6.20-mm1:
> >...
> >  git-v9fs.patch
> >...
> >  git trees
> >...
>
> This patch makes two needlessly global functions static.
>
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Acked-by: Eric Van Hensbergen <ericvh@gmail.com>
