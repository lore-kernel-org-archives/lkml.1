Return-Path: <linux-kernel-owner+w=401wt.eu-S1757799AbXHELwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799AbXHELwU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 07:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbXHELwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 07:52:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:14437 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbXHELwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 07:52:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=P8pW9Gu6/59Y4UXJjLjOITTh8zH524laxnZXeipz1XRQGUxQcf3BMhwNN/sH6Xt2QOispOh9WLXqfrJ2DCfbVYB0aPAXBduZ7RwBo/dDagQLBeFQt81lzHsnkbKQk1fakvi1tIk7YKpqP6h0RQH+lwIeV19PSDwzurJ7bYVaIxA=
Message-ID: <b6a2187b0708050452m1b1b5c5ck163f64a26686d3cc@mail.gmail.com>
Date: Sun, 5 Aug 2007 19:52:07 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Linux 2.6.23-rc2
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>
In-Reply-To: <46B53FDF.5020806@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0708032031480.5037@woody.linux-foundation.org>
	 <b6a2187b0708032213r476204fbh917d3d6672c70528@mail.gmail.com>
	 <b6a2187b0708032234r6ad41be4u5d8142b0b199fcc1@mail.gmail.com>
	 <b6a2187b0708040652l28e9d5aal2cc898f8006906f2@mail.gmail.com>
	 <alpine.LFD.0.999.0708040900170.5037@woody.linux-foundation.org>
	 <46B4C011.8090802@zytor.com>
	 <b6a2187b0708041937u41f3911ap3f1af6115b797d6b@mail.gmail.com>
	 <46B53FDF.5020806@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/5/07, H. Peter Anvin <hpa@zytor.com> wrote:

> Okay, since you're using VGA console this means suspend-to-ram isn't
> restoring the mode.
> Does it matter if you suspend from inside X or not?

Just tested it. It doesn't matter... text console still messed up. X
is ok after resume.


Thanks,
Jeff.
