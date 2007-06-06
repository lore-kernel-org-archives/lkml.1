Return-Path: <linux-kernel-owner+w=401wt.eu-S1760541AbXFFQj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760541AbXFFQj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbXFFQjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:39:22 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:25167 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbXFFQjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:39:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=I6sQfK/BX3z4CL4wvMn1ePVyoxVwPjMjvsMSvJESnQxd74J+G/3ri4Ss2eyY1y5JVnKkkbENOBLNFc6E0G2gNm2wApB8jIZqM+y1FZeKPNe7dyErt8FxqNO2PHeB77O5TmndObOkN7hbKbCX72/1WXioZn8vwZUxg+prhQcTE/I=
Message-ID: <9a8748490706060939i4e667a43xf74b04fb415bdfd3@mail.gmail.com>
Date: Wed, 6 Jun 2007 18:39:21 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Simon Peter" <simon.peter@gmx.de>
Subject: Re: Kernel Timers
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070606150129.49936f60.simon.peter@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070606150129.49936f60.simon.peter@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/07, Simon Peter <simon.peter@gmx.de> wrote:
> Hi,
>
> I see two kernel timer interfaces: The standard and the high-resolution
> timers.

Correct.

> Are there any more?

Not as far as I know.

> Is the whole kernel using these two
> interfaces?
>

As far as I know, yes.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
