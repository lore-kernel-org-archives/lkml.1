Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbXKFCuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbXKFCuN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 21:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbXKFCuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 21:50:00 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:45932 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbXKFCt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 21:49:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bELAir/uCq76OAJbiZ4j49Xum4QU1ju3CHVccdSmDiizpRmvypK2izUNTPN8YUWfFXdX/R4wkS+bQvHg3/c7bLogTdIQXleK9f1ES84nLKuGPIx9Aftd2DvWs8qOWmKCK+WGbr0JO6W2i3NhNfw+ewUiLG98Rjki+KCk3xnmHcw=
Message-ID: <a8e1da0711051849ma591d4k6a816e2de7390347@mail.gmail.com>
Date: Tue, 6 Nov 2007 10:49:55 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Alon Bar-Lev" <alon.barlev@gmail.com>
Subject: Re: [Bluez-devel] [BUG] rfcomm]
Cc: linux-kernel@vger.kernel.org, marcel@holtmann.org,
       bluez-devel@lists.sourceforge.net
In-Reply-To: <a8e1da0711051748u4a0d2d57t4bad26e4f02f559e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200710231950.31313.alon.barlev@gmail.com>
	 <a8e1da0711042108r7cea1a46s8d8b93795c314119@mail.gmail.com>
	 <9e0cf0bf0711050746s5f7910d8teb3c8ae9530b549e@mail.gmail.com>
	 <a8e1da0711051748u4a0d2d57t4bad26e4f02f559e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/6/07, Dave Young <hidave.darkstar@gmail.com> wrote:
> On 11/5/07, Alon Bar-Lev <alon.barlev@gmail.com> wrote:
> > On 11/5/07, Dave Young <hidave.darkstar@gmail.com> wrote:
> > > Hi,
> > > I managed to produce this bug last weekend. I debugged it and found a
> > > rfcomm_dev refcnt BUG.
> > > please try the patch of attachment, sorry for attachement because of
> > > my gmail/mutt configuration problem.
> > >
> > > I post it in below thread:
> > > http://lkml.org/lkml/2007/11/4/207
> >
> > It actually worse... :(
>
Hi,
sorry for reply again, this seems a diffrent issue ...

Regards
dave
