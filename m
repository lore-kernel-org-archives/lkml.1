Return-Path: <linux-kernel-owner+w=401wt.eu-S1760211AbYFJXCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211AbYFJXCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 19:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758690AbYFJXCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 19:02:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:33397 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485AbYFJXCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 19:02:04 -0400
Date: Tue, 10 Jun 2008 16:02:02 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Tim Bird <tim.bird@am.sony.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add diffconfig utility
Message-ID: <20080610160202.3bb9d07f@infradead.org>
In-Reply-To: <1213135624.2534.99.camel@shinybook.infradead.org>
References: <484ED902.9040000@am.sony.com>
	<1213135624.2534.99.camel@shinybook.infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008 23:07:04 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Tue, 2008-06-10 at 12:41 -0700, Tim Bird wrote:
> > +# Added and removed items are shown with a leading plus or minus,
> > +# respectively.  Changed items show the old and new values on a
> > +# single line.
> 
> It'd be really nice if it could give its output in the same form as
> the .config file itself -- so it'd look something like:
> 
> # CONFIG_FOO is not set
> CONFIG_BAR=y
> 
> That can be used with this kind of tool too...
> 

the person who wrote that tool also wrote a similar diff tool ;)
but it's horrible perl I suspect.



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
