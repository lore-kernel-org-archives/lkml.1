Return-Path: <linux-kernel-owner+w=401wt.eu-S1751869AbXBFJPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbXBFJPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 04:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbXBFJPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 04:15:11 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:46903 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbXBFJPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 04:15:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rKC+AwFaPw14474Mzi0UdlFFYhp/7Nbmoae7k5M0Q/PX/fuJ0I/CNN04JgcmevB9ycjqJH5YG3ro+Olb8R1oMmDU6u7oxLciEbI2tM7tMP9TO2mZLLepNclbQKPBsdtl9I5BJt4hYPduJxuE3N1ZtBm9hyy5nC5Pjy/ZiwZEx/o=
Message-ID: <9a8748490702060115x45807f16v608bc4806d7baa0e@mail.gmail.com>
Date: Tue, 6 Feb 2007 10:15:07 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH][0/5] floppy.c: first round of cleanup patches - the simple stuff
Cc: linux-kernel@vger.kernel.org,
       "Trent Waddington" <trent.waddington@gmail.com>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <200702060906.42295.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702060028.31691.jesper.juhl@gmail.com>
	 <200702060906.42295.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/07, Andi Kleen <ak@suse.de> wrote:
> On Tuesday 06 February 2007 00:28, Jesper Juhl wrote:
> > Greetings people,
> >
> > Here is, as promised, the first round of cleanup patches for floppy.c
> > (more will follow later).
>
> I think the real problem with floppy.c is the basic code logic,
> not the coding style. While cleaning the later up is nice, I'm afraid
> it doesn't really help all that much because that code has to be
> replaced anyways.
>

And I will get to the logic later, don't worry :-)   I just wanted to
get all the simple little things out of the way first.

Thank you for commenting.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
