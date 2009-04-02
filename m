Return-Path: <linux-kernel-owner+w=401wt.eu-S933655AbZDBTiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933655AbZDBTiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 15:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762090AbZDBTgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 15:36:43 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46047 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761155AbZDBTgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 15:36:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=kp2HqGfvk/OgoZ9tZHfE01ANGLjerVskrYfZMU30Fm2QeFXppEeCUbIJi2+G1slbEg
         iL4iaMBtJUmssggDSnt4h9SNTVl0686GiA4/WlHEnyY80le3TMxbklnqBlBRLJ6UxcDm
         G1Cq0CbqvCsbPnsR9vgoua+0JuJFWIZJhPFs8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Grant Grundler <grundler@google.com>
Subject: Re: [PATCH] tx4939ide: remove wmb()
Date: Thu, 2 Apr 2009 21:18:52 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090401; KDE/4.2.1; i686; ; )
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-ide@vger.kernel.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
References: <1238516136-15852-1-git-send-email-anemo@mba.ocn.ne.jp> <da824cf30903310936p75469518j9bb28421b1ee81b8@mail.gmail.com>
In-Reply-To: <da824cf30903310936p75469518j9bb28421b1ee81b8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904022118.52909.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 March 2009, Grant Grundler wrote:
> On Tue, Mar 31, 2009 at 9:15 AM, Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> > * define CHECK_DMA_MASK
> > * remove use of wmb()
> >
> > Suggested-by: Grant Grundler <grundler@google.com>
> 
> Thank you for the attribution!
> 
> But I think proper header would be:
>     Reported-by: Grant Grundler <grundler@google.com>
> 
> But in this case, since i've looked at the code and am under the
> illusion I understand it, I'm comfortable with:
>     Reviewed-by: Grant Grundler <grundler@google.com>

Well, you can have both! ;)
