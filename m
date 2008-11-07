Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbYKGGcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbYKGGcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 01:32:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbYKGGb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 01:31:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152AbYKGGbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 01:31:55 -0500
Date: Thu, 6 Nov 2008 22:31:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hitoshi Mitake <mitake@clustcom.com>
Cc: Doug Thompson <norsk5@yahoo.com>, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org, ktaka@clustcom.com
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Message-Id: <20081106223122.8a255211.akpm@linux-foundation.org>
In-Reply-To: <20081107152830.a42766f3.mitake@clustcom.com>
References: <20081105222911.d76e7e1c.mitake@clustcom.com>
	<413709.12821.qm@web50106.mail.re2.yahoo.com>
	<20081106164641.ed369060.akpm@linux-foundation.org>
	<20081107152830.a42766f3.mitake@clustcom.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008 15:28:30 +0000 Hitoshi Mitake <mitake@clustcom.com> wrote:

> On Thu, 6 Nov 2008 16:46:41 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 5 Nov 2008 08:26:12 -0800 (PST)
> > Doug Thompson <norsk5@yahoo.com> wrote:
> > 
> > > > I wrote new version of this driver and tested. It works well.
> > > > This is replacement for old version.
> > > > Or should I send diff of two versions?
> > > 
> > > 
> > > I would suggest sending a diff of what is now in the -mm tree to what it should be.
> > 
> > This driver is now in the mainline kernel so yes, a patch against that
> > kernel is the only appropriate way of updating the driver.
> > 
> 
> Sorry, and thanks for notification, Doug and Andrew.
> This is patch against mainline kernel.
> 
> Signed-off-by: Hitoshi Mitake <mitake@clustcom.com>
> Signed-off-by: Doug Thompson <dougthompson@xmission.com>

We will need a description of this patch for the changelog, please.  We
always do.

