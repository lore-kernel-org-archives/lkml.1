Return-Path: <linux-kernel-owner+w=401wt.eu-S1762030AbYFQXRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762030AbYFQXRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 19:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760158AbYFQXQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 19:16:37 -0400
Received: from sous-sol.org ([216.99.217.87]:48230 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759926AbYFQXQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 19:16:36 -0400
Date: Tue, 17 Jun 2008 16:14:39 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Greg KH <greg@kroah.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [PATCH 2/2] xen: don't drop NX bit
Message-ID: <20080617231439.GL21814@sequoia.sous-sol.org>
References: <4856E2D4.3020402@goop.org> <20080616223508.GA1165@kroah.com> <4856EE79.1000205@goop.org> <20080616233730.GA25506@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080616233730.GA25506@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH (greg@kroah.com) wrote:
> Heh, Novell isn't using it right now, look at the series of patches in
> opensuse 11.0 for proof of that :(

Yeah, be much better when the fwd porting madness has stopped.
