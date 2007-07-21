Return-Path: <linux-kernel-owner+w=401wt.eu-S1762194AbXGUS7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762194AbXGUS7Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 14:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbXGUS7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 14:59:04 -0400
Received: from qb-out-0506.google.com ([72.14.204.225]:30011 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbXGUS7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 14:59:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FWjaaURCJwdk9oSQi/BWew3ZD66ELSkuSLyfj6QGep6Tcr3ecmENO4F00T7MM9/dky95tI3WwNIrWxMWH1+RREsK1ec08Nt/9yuK3NWu1qD1/LJNm770P6Ry6VurQQMxh6yvjTI+jDQVhLWQ25779kyX8L6c6TU0zv9WVd73JTw=
Message-ID: <9a8748490707211159i4a54b5cbl822503ce94252c14@mail.gmail.com>
Date: Sat, 21 Jul 2007 20:59:00 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH][14/37] Clean up duplicate includes in drivers/spi/
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       spi-devel-general@lists.sourceforge.net, "Nicolas Pitre" <nico@cam.org>,
       "Aubrey Li" <aubrey.li@analog.com>
In-Reply-To: <200707211124.53195.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200707211702.56466.jesper.juhl@gmail.com>
	 <200707211124.53195.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/07/07, David Brownell <david-b@pacbell.net> wrote:
> On Saturday 21 July 2007, Jesper Juhl wrote:
> > Hi,
> >
> > This patch cleans up duplicate includes in
> >       drivers/spi/
> >
> >
> > Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
>
> ACK ... although, on general principles I suspect there are more
> needless includes to remove, these are just especially obvious.  :)
>
Yup. This patch series just removes the bulk of the low hanging fruit
- there's still more to do for an enterprising janitor in need of a
task. But you have to start somewhere :-)


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
