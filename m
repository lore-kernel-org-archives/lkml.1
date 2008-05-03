Return-Path: <linux-kernel-owner+w=401wt.eu-S1763267AbYECMBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763267AbYECMBN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 08:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758237AbYECMA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 08:00:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:58229 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbYECMA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 08:00:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=GdeE9mV+JANVO/8L2cw+k7HZgtbBnCcSm/muYgevKNjH8UryFw18ackyM+59auiDxSkdJBagtJxbyVdzsCDSgfr1JVb4SgLVs0u8RyZm+UFHhqae3oyZnrKqnrFBGiyQ7A52a8yq8vG2krhaF89QcoeylSy2ziN0XBgAEOv/kFM=
Message-ID: <ed10ee420805030500s39af3174v5d313f232dd7eb42@mail.gmail.com>
Date: Sat, 3 May 2008 05:00:56 -0700
From: "SL Baur" <steve@xemacs.org>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: How to reduce the number of open kernel bugs
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080503112118.GK5838@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080502124210.GB5838@cs181133002.pp.htv.fi>
	 <ed10ee420805030313r457d8cdfjdbcb346ae928c125@mail.gmail.com>
	 <20080503112118.GK5838@cs181133002.pp.htv.fi>
X-Google-Sender-Auth: 39558ac8031fc524
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/3/08, Adrian Bunk <bunk@kernel.org> wrote:

> That's a problem elsewhere, but not the problem here.
>
>  As far as I know this maintainer developed and maintaines this driver as
>  a hobby.

I'm not sure what point you're trying to make.  The point I was
trying to make was against the folks who were suggesting
adding certain metrics to Linux kernel patching.  The biggest
number of reversions script that was just posted pointed at
Linus and Andrew as the biggest villains, or that's how I read
it and that is clearly bogus.

I have had similar experiences with people *paid* to handle
bug reports, requests, etc. and had eerily similar dialogs.  Why
should a volunteer working in his spare time behave any
differently?

What am I missing?

-sb
