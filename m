Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbYHSIn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbYHSIn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 04:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbYHSInT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 04:43:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753838AbYHSInS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 04:43:18 -0400
Date: Tue, 19 Aug 2008 01:43:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       dbrownell@users.sourceforge.net
Subject: Re: [PATCH] Make gpiochip label const
Message-Id: <20080819014305.44a1f9b8.akpm@linux-foundation.org>
In-Reply-To: <20080817190035.GA29170@doriath.ww600.siemens.net>
References: <1218573588-25528-1-git-send-email-dbaryshkov@gmail.com>
	<20080812220619.D2011362B0F@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	<20080817190035.GA29170@doriath.ww600.siemens.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Aug 2008 23:00:35 +0400 Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:

> On Tue, Aug 12, 2008 at 03:06:19PM -0700, David Brownell wrote:
> > > From dbaryshkov@gmail.com  Tue Aug 12 13:54:29 2008
> > > From: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > > To: linux-kernel@vger.kernel.org
> > > Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>,
> > > 	David Brownell <dbrownell@users.sourceforge.net>
> > > Subject: [PATCH] Make gpiochip label const
> > > Date: Wed, 13 Aug 2008 00:39:48 +0400
> > >
> > > Mark gpiochip label as a const char pointer.
> > >
> > > Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> > > Cc: David Brownell <dbrownell@users.sourceforge.net>
> > 
> > Acked-By: David Brownell <dbrownell@users.sourceforge.net>
> > 
> 
> Sorry to disturb, but will this make into 2.6.27-rc? Thanks.
> 

Ordinarily it would not.  Is there some reason why you think it should?
