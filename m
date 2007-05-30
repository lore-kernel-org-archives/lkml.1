Return-Path: <linux-kernel-owner+w=401wt.eu-S1755780AbXE3OiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbXE3OiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 10:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbXE3Oh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 10:37:57 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:43237 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbXE3Oh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 10:37:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=k+WJ1nYh2nYb6j/Hj9nK/uk1Ve/85JYlIrCZsDNeCp5vAchkGkS+CLeoSsZhMyutWuWvTTY/tqcaXRJjisVq+f9O3b5e1txxA0RzwwDw/m6oFoczinZcou+/HHrGoXfPGVTVmPpq0tYZ2YZhM5sj+i6xW9oExw+T6ObLj91Qhrc=
Message-ID: <2bd9ebfa0705300737t4f11ee71mca114b37a969db01@mail.gmail.com>
Date: Wed, 30 May 2007 20:07:53 +0530
From: "Tej Parkash" <tejparkash.d@gmail.com>
To: sam@ravnborg.org
Subject: Re: Linux-kernel-digest Digest, Vol 32, Issue 795
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <2bd9ebfa0705300735l51dcf4ceubf7f83ab44703010@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <mailman.13746.1180510421.20629.linux-kernel-digest@lists.us.dell.com>
	 <2bd9ebfa0705300735l51dcf4ceubf7f83ab44703010@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/07, Tej Parkash <tejparkash.d@gmail.com> wrote:
> > > >
> > > > while building module i was getting following warning and it terminate
> > > > module building stage
> > > The below are only warnings and your build should succeed.
> > >
> > > It is obviously i386 - is it a clean allmodconfig or any changes?
> > > Is it latest -linus or some older version of the codebase?
> > Did an allmodconfig build of i386 - I see (almost) all warnings here.
> > So I will take a look based on this.

 yaa i got the warning but as i said building stage is also getting
terminated, without any error.

> The MODPOST stage took a while but it proceeded with no hick-ups.
>  MDOPSOT deals with ~2000 modules in my case and that consumes a bit
>  of memory. Maybe you are hitting the limit with respect to available RAM / SWAP?
>
>         Sam
>
>
 I don't think so that RAM or SWAP space is a constraint, is it related
 to kernel build option or some change in arch. config files
 I am not aware of the required patches for the same.


 thanks
 TEJ
