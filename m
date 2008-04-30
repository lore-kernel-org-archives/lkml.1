Return-Path: <linux-kernel-owner+w=401wt.eu-S1761355AbYD3J10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761355AbYD3J10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 05:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbYD3J1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 05:27:19 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:34984 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbYD3J1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 05:27:18 -0400
Date: Wed, 30 Apr 2008 11:27:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: RFC: make MAINTAINERS email addresses easier to copy/paste
Message-ID: <20080430092752.GC31644@uranus.ravnborg.org>
References: <200804291459.56300.bjorn.helgaas@hp.com> <20080430084938.GA31984@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430084938.GA31984@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 04:49:38AM -0400, Christoph Hellwig wrote:
> On Tue, Apr 29, 2008 at 02:59:56PM -0600, Bjorn Helgaas wrote:
> > The current MAINTAINERS file format makes it a nuisance to
> > copy both the display name and the actual address.  So
> > I propose that we fold together the current "P:" and "M:"
> > lines using something similar to the filter below.
> 
> Why do you want to copy the real name?  It's entirely superflous for
> mail routing.
I always use the real name in my Cc: tags in my patches.
And I prefer to name people by their name - not their mail address.

So I often use their real name in to: also.
But for me it is easier copy to the Cc: tag that is most important.

	Sam
