Return-Path: <linux-kernel-owner+w=401wt.eu-S1760744AbXEMVGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760744AbXEMVGm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 17:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754857AbXEMVGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 17:06:36 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:27354 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbXEMVGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 17:06:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CY+4Xf1J/uRD+2wZqoYmGvRzzLLTdMi04Jw6m/xzNLyhWyORXZEdMaJOUKG4RawCUdemrLhNKdEAX+6zAKhJqEte3yymsQQsXaWfp8Zd2l/3ZpFhH52m088GxNHtKyqTeEr4OFe2kh0ywT2vPADaCdWTHvmI10JHjqFTxqGHXXM=
Message-ID: <86802c440705131406u36340ad4tbc4d81c7df2356bf@mail.gmail.com>
Date: Sun, 13 May 2007 14:06:33 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH]x86_64: build and use GDT on copied compressed kernel
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Vivek Goyal" <vgoyal@in.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <m1646wpkr5.fsf@ebiederm.dsl.xmission.com>
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
	 <86802c440705130027vce147dma85a07de6489d666@mail.gmail.com>
	 <86802c440705131101r5b32e0b9j28e2248813b25b64@mail.gmail.com>
	 <m1646wpkr5.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/13/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> We have big boot protocol revision coming up to more clearly document
> what is needed to work with the native entry points.  It is a 2.6.23
> targeted thing and that is one of the things that we are likely to
> look at.

Good, where is the thread for that?

YH
