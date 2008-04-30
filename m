Return-Path: <linux-kernel-owner+w=401wt.eu-S1760930AbYD3IHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760930AbYD3IHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 04:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758095AbYD3IHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 04:07:41 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:37347 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757590AbYD3IHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 04:07:40 -0400
Date: Wed, 30 Apr 2008 10:08:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: make MAINTAINERS email addresses easier to copy/paste
Message-ID: <20080430080814.GA31040@uranus.ravnborg.org>
References: <200804291459.56300.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804291459.56300.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 02:59:56PM -0600, Bjorn Helgaas wrote:
> I like to use display names for email addresses, e.g.,
> "Bjorn Helgaas <bjorn.helgaas@hp.com>" instead of just
> "bjorn.helgaas@hp.com".
> 
> The current MAINTAINERS file format makes it a nuisance to
> copy both the display name and the actual address.  So
> I propose that we fold together the current "P:" and "M:"
> lines using something similar to the filter below.

I would welcome this change as it makes is simpler
to cc relevant people on patches - with their full name.

	Sam
