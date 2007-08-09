Return-Path: <linux-kernel-owner+w=401wt.eu-S965773AbXHIOnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965773AbXHIOnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936647AbXHIOnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:43:12 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:34562 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938136AbXHIOnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:43:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Xb4dY7IdmbGDfE1iwr13EnEIWXoV2gAhmcLrvNEkcTuMbhzIVCq6DkXbeawc3KG9rqEW3KomDvIlbj7PWNLl7n3XouIw3UwbGIaxGX3hPIIdrQqJ9LPTjDpUO0Eoumnya3zCLN+JlsXCP57/A0aYaZNYFAjJCnwBHznD66B2prM=
Message-ID: <4104961b0708090743t810dadbp37521425120c2ed2@mail.gmail.com>
Date: Thu, 9 Aug 2007 22:43:10 +0800
From: "jidong xiao" <jidong.xiao@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: What does 'if EMBEDDED' mean?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070809141621.GO6997@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4104961b0708090711j291974cbx933e1262ba1935f6@mail.gmail.com>
	 <20070809141621.GO6997@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/07, Adrian Bunk <bunk@kernel.org> wrote:
>
> Say "y" at
>  General setup
>    Configure standard kernel features (for small systems)
>
> cu
> Adrian
>

Thank you, Adrian, it's very clear.

By the way, can sysfs be compiled as a module?Does bool type mean this
option cannot be compiled as a module?

Regards
Jason
