Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451AbXJBQEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbXJBQEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 12:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbXJBQEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 12:04:42 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3071 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbXJBQEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 12:04:41 -0400
Subject: Re: [patch] printk: add KERN_CONT annotation
From: Joe Perches <joe@perches.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Ingo Molnar <mingo@elte.hu>, Willy Tarreau <w@1wt.eu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0710021744060.7130@fbirervta.pbzchgretzou.qr>
References: <20070928105345.GC18163@shadowen.org>
	 <20071001064448.GA4239@elte.hu>
	 <20071001003007.4e90143b.akpm@linux-foundation.org>
	 <20071002043408.GM10199@1wt.eu> <20071002051852.GC28345@elte.hu>
	 <1191339692.13170.18.camel@localhost>
	 <Pine.LNX.4.64.0710021744060.7130@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 09:03:38 -0700
Message-Id: <1191341018.13170.27.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-02 at 17:45 +0200, Jan Engelhardt wrote:
> always use printk("%s", var)

You have to use indirect arguments to log something?
Don't you think that's a stupid rule?

Look at the version strings that are used as __devinitdata.


