Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbZAASuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbZAASuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 13:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbZAASuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 13:50:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36560 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbZAASuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 13:50:22 -0500
Date: Thu, 1 Jan 2009 13:50:08 -0500
From: Dave Jones <davej@redhat.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, "J.H." <warthog19@eaglescrag.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, ftpadmin@kernel.org
Subject: Re: [KORG] Announcement: patchwork.kernel.org
Message-ID: <20090101185008.GB13600@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Kyle Moffett <kyle@moffetthome.net>,
	Sitsofe Wheeler <sitsofe@yahoo.com>,
	"J.H." <warthog19@eaglescrag.net>,
	linux-kernel <linux-kernel@vger.kernel.org>, ftpadmin@kernel.org
References: <fa.f9uNEYqmpJX02C68okHq8SDYyFI@ifi.uio.no> <495CD285.1000501@yahoo.com> <20090101183646.GA13585@redhat.com> <f73f7ab80901011043s193b5ac9s6756f9b401fc148@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f73f7ab80901011043s193b5ac9s6756f9b401fc148@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 01, 2009 at 01:43:47PM -0500, Kyle Moffett wrote:
 > On Thu, Jan 1, 2009 at 1:36 PM, Dave Jones <davej@redhat.com> wrote:
 > > On Thu, Jan 01, 2009 at 02:26:13PM +0000, Sitsofe Wheeler wrote:
 > >  > J.H. wrote:
 > >  > > If you have problems, concerns or issues please e-mail ftpadmin@kernel.org.
 > >  >
 > >  > I get a python error when I try and do a search:
 > >  > http://patchwork.kernel.org/project/LKML/list/?q=lzma
 > >
 > > I've seen a number of tracebacks. They seem to be transient,
 > > in that reloading any particular page eventually causes it
 > > to trigger.  Reloading then makes it work again.
 > 
 > Unfortunately it seems to have triggered on my attempt to register an
 > account... and as a result I didn't get the subscription email.  Would
 > it be possible for one of the admins to either confirm my subscription
 > or resend the email?  I used this email address on the web form.

Something fishy seems up with the mail registration thing.
It said it had sent it, and JH even confirmed in the logs that it
went out, but for some reason, it never hit my inbox.

I sent Jeremy Kerr a feature request for a future version of patchwork
to have a "resend" button.

	Dave

-- 
http://www.codemonkey.org.uk
