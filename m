Return-Path: <linux-kernel-owner+w=401wt.eu-S1758191AbXEMHxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191AbXEMHxt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 03:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757433AbXEMHxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 03:53:42 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:3642 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757278AbXEMHxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 03:53:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=STkI3qhkodGVp4SEc5aC0YVIcCim0S7+qnJYxWAafRLlAoR1GINEtXdbVOYplU8sj0ltiGnTdHt1dytMX3uHKsHQ2rbuUkv7RXYqQwscmOoabZhC1MrfGQoI17rk7Hl90kXAd0ZQyLrkTLtfplsCsmOh291ztF23cXsodqr373E=
Message-ID: <86802c440705130027vce147dma85a07de6489d666@mail.gmail.com>
Date: Sun, 13 May 2007 00:27:49 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH]x86_64: build and use GDT on copied compressed kernel
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Vivek Goyal" <vgoyal@in.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <m11whlqk1g.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440705122233y327756e7te534199f46b2059d@mail.gmail.com>
	 <m1ejllqmo8.fsf@ebiederm.dsl.xmission.com>
	 <86802c440705122329y27c6ef92v8cff43d52b99ae69@mail.gmail.com>
	 <m1abw9qkve.fsf@ebiederm.dsl.xmission.com>
	 <86802c440705122355r5f811d5bg2006b0b22ca885e6@mail.gmail.com>
	 <m11whlqk1g.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/13/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Probably variables in misc.c
it is vidmem in misc.c

YH
