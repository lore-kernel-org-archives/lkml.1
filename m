Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbYADEHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbYADEHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 23:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYADEHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 23:07:10 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:8285 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbYADEHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 23:07:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tb820Gy0tlB6wLBBgaEns7culs7+ilqanVfJEaM2O1WjOz2/fySMInVKwnnAN8Y+aEFHk31smucQHDunDThTK2cBqhMI531LV8vQI22ySnMVaiMA2Exejo4Le1PFeAIOFlKIt/P2ndFlrriizoieycivrcRscEzoKHUaGP9WS+A=
Message-ID: <386072610801032007v341c78e5ufb5349ddeedf326f@mail.gmail.com>
Date: Fri, 4 Jan 2008 12:07:07 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Josh Boyer" <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] Rework arch specific Makefiles to use mkubootimg
Cc: "Ben Dooks" <ben@fluff.org>, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk, hskinnemoen@amtel.com, bryan.wu@analog.com,
       lethal@linux-sh.org
In-Reply-To: <20080103165854.0d6accef@zod.rchland.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080103160104.171f9aaa@zod.rchland.ibm.com>
	 <20080103160406.7ef5ecfe@zod.rchland.ibm.com>
	 <20080103224139.GA4178@fluff.org.uk>
	 <20080103165854.0d6accef@zod.rchland.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 4, 2008 6:58 AM, Josh Boyer <jwboyer@linux.vnet.ibm.com> wrote:
> On Thu, 3 Jan 2008 22:41:40 +0000
> Ben Dooks <ben@fluff.org> wrote:
>
> > On Thu, Jan 03, 2008 at 04:04:06PM -0600, Josh Boyer wrote:
> > > Rework the architecture specific Makefiles to use the in-kernel version of
> > > the mkubootimg tool.
> > >
> > > Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> >
> > A CC: to RMK and any other arch maintainers being touched by this
> > would have useful too.
>
> D'oh.  I thought I had fixed that in this round.  Bit late now, but
> CC'd.
>

It is OK for Blackfin, Thanks.
But Mike is still discussing with you about the first Patch of this series.

Acked-by: Bryan Wu <bryan.wu@analog.com>
