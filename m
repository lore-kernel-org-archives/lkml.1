Return-Path: <linux-kernel-owner+w=401wt.eu-S1753601AbZA3J3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbZA3J3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 04:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbZA3J3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 04:29:09 -0500
Received: from mail.gmx.net ([213.165.64.20]:55645 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752092AbZA3J3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 04:29:07 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+CKs9/v1OCgsLMJzZeB5oPxnwRgXJIt01yoYhZM6
	IRp6KbjmA7eVdH
Subject: Re: scheduler nice 19 versus 'idle' behavior / static low-priority
	scheduling
From: Mike Galbraith <efault@gmx.de>
To: Nathanael Hoyle <nhoyle@hoyletech.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1233305747.17301.33.camel@localhost>
References: <1233294584.28741.2.camel@localhost>
	 <alpine.LSU.2.00.0901300710200.999@fbirervta.pbzchgretzou.qr>
	 <1233297635.17301.11.camel@localhost>
	 <alpine.LSU.2.00.0901300818580.28427@fbirervta.pbzchgretzou.qr>
	 <1233302349.17301.27.camel@localhost>
	 <1233302861.6061.14.camel@marge.simson.net>
	 <1233305747.17301.33.camel@localhost>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 10:29:02 +0100
Message-Id: <1233307742.7673.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 03:55 -0500, Nathanael Hoyle wrote:

> Any reason not to apply this fairly simple patch against the 2.6.27
> series kernel I'm running now? Are there other relevant changes you're
> aware of in the later kernel revs for this problem?

You'd have to dig out a few other changes in order to apply it to 27.

Yes there are other relevant changes, but unless you're familiar with
the source, you'll be better off just trying 28.stable of the latest rc.
You'll have to find extract and back-port otherwise.

	-Mike

