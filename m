Return-Path: <linux-kernel-owner+w=401wt.eu-S1761908AbXJOWy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761908AbXJOWy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbXJOWyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:54:15 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:38377
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbXJOWyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:54:14 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Greg KH <greg@kroah.com>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 17:54:07 -0500
User-Agent: KMail/1.9.6
Cc: James Bottomley <James.Bottomley@steeleye.com>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
References: <200710112011.22000.rob@landley.net> <200710150336.15774.rob@landley.net> <20071015172513.GA5738@kroah.com>
In-Reply-To: <20071015172513.GA5738@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710151754.08795.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2007 12:25:13 pm Greg KH wrote:
> Oh, and this seems like a very Ubuntu specific rant, might I suggest you
> contact the Ubuntu developers about this?  The kernel doesn't dictate
> that the distro has to use these long identifiers, and there is nothing
> we can do about it.

I was just trying to use the strangeness in a large distributor's first 
attempt at this functionality as an evidence that it's apparently not trivial 
to get even the common cases right under the new model, while the common 
cases used to be trivial to get right under the old model.  (Or at least it 
seemed so to me.)

I think I've exhausted this line of argument, though, and will stop now.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
