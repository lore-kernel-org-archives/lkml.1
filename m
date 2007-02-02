Return-Path: <linux-kernel-owner+w=401wt.eu-S1423051AbXBBNOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423051AbXBBNOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 08:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423053AbXBBNOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 08:14:08 -0500
Received: from wx-out-0506.google.com ([66.249.82.238]:62541 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423051AbXBBNOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 08:14:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZXOSz9afByDonKPjAsEhBjx/I/cv7ZcvBMiqLlDOnXQMXKQeuQSa54jy5eLEByuFGx9ISjr1XC3Xur05VVj2qmhgqFA+RS9XiUb91anPHncu8YUN7Y8efyvvSJOLVC5exEbSVMB4FFUw/wiemn5WkGV/3cAXPTbkstk0uKvC4u8=
Message-ID: <9a8748490702020514w46c38ec3p3549ec0142e7eb6f@mail.gmail.com>
Date: Fri, 2 Feb 2007 14:14:06 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Paolo Ornati" <ornati@fastwebnet.it>
Subject: Re: Slower CPU frequency reported by the kernel
Cc: "Francis Moreau" <francis.moro@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070202130408.05212b10@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0702020311o54789ef6xff819dc3b492b005@mail.gmail.com>
	 <20070202130408.05212b10@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/07, Paolo Ornati <ornati@fastwebnet.it> wrote:
> On Fri, 2 Feb 2007 12:11:25 +0100
> "Francis Moreau" <francis.moro@gmail.com> wrote:
>
> > Hi,
> >
> > I'm using a PC with AMD 64 3000+ cpu which is theoricaly running at
> > 2Ghz. But when looking at /proc/cpuinfo, the kernel reports that it
> > runs only at 1Ghz:
> >
I agree that that is the most logical explanation, but in theory it
could also be that he has changed bios settings and underclocked the
processor.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
