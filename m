Return-Path: <linux-kernel-owner+w=401wt.eu-S967691AbXEHTBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967691AbXEHTBr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967647AbXEHTBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:01:44 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:7792 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967601AbXEHTBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:01:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qwS/2Z5JY4PR5LJD++XGOAIJgMyayqAb8sa6K5CG0iGP3ERP7StGv212dzC9H3TGw1ATe8BUBgzUxU+FkLYG73SrsaJ2M+gSzqJ6m1KJnV/PJiBSVUg2jJ4sxwBugXq/irELWdx/lJfXuFvvFhKjKLEVa86XEIhHNcy1Mr3MO7o=
Message-ID: <86802c440705081201u3c44127cn88bd155f2d827f2c@mail.gmail.com>
Date: Tue, 8 May 2007 12:01:40 -0700
From: yhlu <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
Cc: vgoyal@in.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Gerd Hoffmann" <kraxel@redhat.com>, "Jeff Garzik" <jeff@garzik.org>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <86802c440705081151r6bfd82e4o50c6a34b2b2a833f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4634483E.9030307@goop.org> <4638FE1B.9050901@zytor.com>
	 <46390523.5010809@goop.org> <463909AF.9040205@zytor.com>
	 <20070503045031.GA5794@in.ibm.com>
	 <m1tzuuv24z.fsf@ebiederm.dsl.xmission.com>
	 <86802c440705080941y69ddd5d6lab170c5f3967f148@mail.gmail.com>
	 <m1sla7i68s.fsf@ebiederm.dsl.xmission.com>
	 <86802c440705081033s19365843i5b955ae175de73eb@mail.gmail.com>
	 <86802c440705081151r6bfd82e4o50c6a34b2b2a833f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> the mkelfImage 2.7 patch is at

https://lists.linux-foundation.org/pipermail/fastboot/attachments/20061108/009064a6/mkelfImage_2.7_amd64_1108-0001.obj

YH
