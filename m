Return-Path: <linux-kernel-owner+w=401wt.eu-S1763591AbZEHVuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763591AbZEHVuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 17:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbZEHVuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 17:50:04 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:36647 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbZEHVuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 17:50:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aK42dNynRHXcDpJPBp6SVLe/tptoSjb5j4JX71vUAgm8CUJkd4AYT2Tahd1nmKdGA8
         9LPFTdyfD82OUrKka90RViA8X2Yp7a6ueMMYZcYiv7KkxnOh9PEpVl8lB0/uc9vxfVEq
         YcAApHe++vbWx/cAc3P1PGC1gDjEuIV6gJr2U=
Subject: Re: [PATCH 0/13] RFC ONLY - kdb for kgdb
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       kdb@oss.sgi.com
In-Reply-To: <1241817800-9320-1-git-send-email-jason.wessel@windriver.com>
References: <1241817800-9320-1-git-send-email-jason.wessel@windriver.com>
Content-Type: text/plain
Date: Sat, 09 May 2009 00:49:56 +0300
Message-Id: <1241819396.4735.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-08 at 16:23 -0500, Jason Wessel wrote:
> This patch series is a request for comments on several levels.
> 
> 1) Do people find kdb useful? (See * and **)
> 2) Would kdb folks be willing to use it if it was a front end to kgdb?
> 3) Does kdb have a future in the mainline kernel?
> 4) Is this a reasonable approach to have some level of
>    unification to end up with a more robust kernel debugger?
> 
> * This is not meant to be a religious war
> 

I am just a ordinary user of linux, but I want to say that I enjoyed the
kdb back when I used it. I really would like to see that in kernel.


But it would be even better to see a kdb over ethernet first (I have no
serial port in my notebook....)

Best regards,
	Maxim Levitsky

