Return-Path: <linux-kernel-owner+w=401wt.eu-S935299AbXEIEmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935299AbXEIEmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 00:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935191AbXEIEmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 00:42:06 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:28033 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935008AbXEIEmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 00:42:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TErtHRCUhoHjh4UzO31fg8scTY+b2OTPz7Srjd8vhFq/rU9N4TEq4DfxNdAQP6Gj15A0XaOCqZZ3y7J/KdXdyhUQJBJN+dfskzXJ6XST4lXOI1xZ1qWydK0sQB85qJSh3ug8rOvAADyIIunKVEyY7T5Earpk/YtKB+/fe4J1xgA=
Message-ID: <86802c440705082142u7ee2b402q9ae09edbed32766a@mail.gmail.com>
Date: Tue, 8 May 2007 21:42:02 -0700
From: yhlu <yhlu.kernel@gmail.com>
To: vgoyal@in.ibm.com
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Gerd Hoffmann" <kraxel@redhat.com>, "Jeff Garzik" <jeff@garzik.org>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <20070509033348.GA12361@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4638FC39.4010101@goop.org> <46390523.5010809@goop.org>
	 <463909AF.9040205@zytor.com> <20070503045031.GA5794@in.ibm.com>
	 <m1tzuuv24z.fsf@ebiederm.dsl.xmission.com>
	 <86802c440705080941y69ddd5d6lab170c5f3967f148@mail.gmail.com>
	 <m1sla7i68s.fsf@ebiederm.dsl.xmission.com>
	 <86802c440705081033s19365843i5b955ae175de73eb@mail.gmail.com>
	 <86802c440705081151r6bfd82e4o50c6a34b2b2a833f@mail.gmail.com>
	 <20070509033348.GA12361@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/8/07, Vivek Goyal <vgoyal@in.ibm.com> wrote:
> On Tue, May 08, 2007 at 11:51:35AM -0700, yhlu wrote:
> This message generally appears if you did not specify --args-linux
> on kexec command line while loading vmlinux.
>
besides elf-x86_64, still need --args-linux to pass sth? but how to
let it load ramdisk?

YH
