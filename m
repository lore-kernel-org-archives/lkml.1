Return-Path: <linux-kernel-owner+w=401wt.eu-S1752747AbYHQTCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbYHQTCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 15:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbYHQTCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 15:02:07 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:25871 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYHQTCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 15:02:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HhZ3EXB2x3v2U13u8fsYun4PuGZInl3DfthBRM4yyAd/myf6z2+loMY8C3kva43Wmw
         eG4QulybuPzszBInkRQaa1lPz6ICGOK/kPDoC96rVss1yPDmsVpv3PiaupcK8iduSZOq
         uQJxVK6WAwTrm7Ksqx4NHSYlYPsI2aTiFAHu8=
Date: Sun, 17 Aug 2008 23:00:35 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net
Subject: Re: [PATCH] Make gpiochip label const
Message-ID: <20080817190035.GA29170@doriath.ww600.siemens.net>
References: <1218573588-25528-1-git-send-email-dbaryshkov@gmail.com> <20080812220619.D2011362B0F@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080812220619.D2011362B0F@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 03:06:19PM -0700, David Brownell wrote:
> > From dbaryshkov@gmail.com  Tue Aug 12 13:54:29 2008
> > From: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > To: linux-kernel@vger.kernel.org
> > Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>,
> > 	David Brownell <dbrownell@users.sourceforge.net>
> > Subject: [PATCH] Make gpiochip label const
> > Date: Wed, 13 Aug 2008 00:39:48 +0400
> >
> > Mark gpiochip label as a const char pointer.
> >
> > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > Cc: David Brownell <dbrownell@users.sourceforge.net>
> 
> Acked-By: David Brownell <dbrownell@users.sourceforge.net>
> 

Sorry to disturb, but will this make into 2.6.27-rc? Thanks.

-- 
With best wishes
Dmitry

