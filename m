Return-Path: <linux-kernel-owner+w=401wt.eu-S1758886AbXHMTYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886AbXHMTYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 15:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965854AbXHMTWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 15:22:19 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:46296 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966021AbXHMTWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 15:22:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NRCC7KU3i+hK8y0GoKFI6ytHIi9rHmL1EXyke2FP45X/IUppuKASrx3W+VNCFaFckOj6buvVMyr8IB8kN9QtMWJwsKMj+1kdjJCMd8p1sJWLMJAUxW+ZupEQJ90ZlRNI4xiWdmD17HTDWqnbi4ZOeo5QFFEv6VN4obURQ8VmljM=
Message-ID: <1a297b360708131222t55be6fbax78a6659762a98e7e@mail.gmail.com>
Date: Mon, 13 Aug 2007 23:22:04 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Joe Perches" <joe@perches.com>
Subject: Re: [v4l-dvb-maintainer] [PATCH] [534/2many] MAINTAINERS - VIDEO FOR LINUX
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       video4linux-list@redhat.com, torvalds@linux-foundation.org,
       v4l-dvb-maintainer@linuxtv.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1187030038.10249.237.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46bffca0.bx1Cr4B33dN1FJPN%joe@perches.com>
	 <1187028910.664.11.camel@gaivota>
	 <1187030038.10249.237.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/07, Joe Perches <joe@perches.com> wrote:
> On Mon, 2007-08-13 at 15:15 -0300, Mauro Carvalho Chehab wrote:
> > There are more include files to be added, for the older V4L APIs:
> > F: include/linux/video_decoder.h
> > F: include/linux/videodev.h
>
> VIDEO FOR LINUX
> P:      Mauro Carvalho Chehab
> M:      mchehab@infradead.org
> M:      v4l-dvb-maintainer@linuxtv.org
> L:      video4linux-list@redhat.com
> W:      http://linuxtv.org
> T:      git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
> S:      Maintained
> F:      Documentation/video4linux/


> F:      drivers/media/

This means everything under media is maintained under V4L. Incorrect
