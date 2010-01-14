Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690Ab0ANDMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab0ANDMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 22:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002Ab0ANDL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 22:11:59 -0500
Received: from comsrv.aao.GOV.AU ([192.231.167.2]:37750 "HELO
	comsrv.aao.gov.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752903Ab0ANDL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 22:11:59 -0500
Date: Thu, 14 Jan 2010 14:13:45 +1100
From: Scott Smedley <ss@aao.gov.au>
To: Greg KH <greg@kroah.com>
Cc: Marin Mitov <mitov@issp.bas.bg>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Yet another dt3155 driver for drivers/staging
Message-ID: <20100114031345.GA22542@aao.gov.au>
Reply-To: ss@aao.gov.au
References: <201001122242.22774.mitov@issp.bas.bg> <20100112235221.GA20761@aao.gov.au> <20100113001724.GB29904@kroah.com> <201001130816.43855.mitov@issp.bas.bg> <20100114010335.GB20569@aao.gov.au> <20100114023655.GA25618@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100114023655.GA25618@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

> We don't need to worry about older kernel versions from here on out.

Ok.

> So that leaves the functionality issues.   Is the only difference that
> one can capture faster than the other?

As mentioned, Marin's driver only supports CCIR mode & it
hasn't been tested with multiple boards.

>  They should be using the v4l
> apis so userspace shouldn't be a difference either, right?

No. They are both standalone drivers. If we want V4L2 compatibility
we would have to modify (either) driver significantly.

Scott. :)
