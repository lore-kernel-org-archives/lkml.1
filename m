Return-Path: <linux-kernel-owner+w=401wt.eu-S1757052AbZAXDUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052AbZAXDUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 22:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754108AbZAXDUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 22:20:09 -0500
Received: from rv-out-0506.google.com ([209.85.198.230]:30620 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbZAXDUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 22:20:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wmgrQExZ5jsX7tQE9OaSzAsfNg74QlwKF108goF35HMGfWmk39AZu94Dqj0wXDTNwy
         G77emPd4KDYfDfW7mk2ZQ/eckTRMkySPT8txmzF2Sr/8wmtawFjYLPtNYWtaw4gWx9Ur
         eFYCV+Hj7J/DyeEubVY0TSR6f2Lw41bkP3e00=
MIME-Version: 1.0
In-Reply-To: <200901240503.35695.ionut.leonte@gmail.com>
References: <3f9a31f40901222126t5baf80f8t12513dc9fd9b3f29@mail.gmail.com>
	 <200901240503.35695.ionut.leonte@gmail.com>
Date: Sat, 24 Jan 2009 08:50:05 +0530
Message-ID: <3f9a31f40901231920s122eeddfw7c58d89431c97c43@mail.gmail.com>
Subject: Re: How can I fix errors and warnings in nvidia module for Tesla 
	C1060
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Ionut Leonte <garglkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-nvidia@lists.surfsouth.com, adaplas@gmail.com,
       npaci-rocks-discussion@sdsc.edu, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2009 at 8:33 AM, Ionut Leonte <garglkml@gmail.com> wrote:
> According to the log you attached ("Kernel messages" section):
>
>   nvidia: module license 'NVIDIA' taints kernel.
>   NVRM: No NVIDIA graphics adapter found!
>
> Are you sure you're using the correct driver ?
>

Nvidia Tesla C1060 has no output, so I was using intel motherboard
garphics, when I disable intel motherboard graphics adapter
installation processes able to find nvidia graphics adapter and build
the nvidia module.

But now I got another problem I use various git kernels trees, so I
need to build these modules for each kernel tree. And seems nvidia is
not disclosing the source code for Nvidia Telsa Series module :-(

--
JSR
