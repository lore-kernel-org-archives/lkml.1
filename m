Return-Path: <linux-kernel-owner+w=401wt.eu-S1755961AbXGWLty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbXGWLty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 07:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbXGWLtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 07:49:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41973 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbXGWLtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 07:49:46 -0400
Date: Mon, 23 Jul 2007 12:49:36 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Alan Modra <amodra@bigpond.net.au>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roland McGrath <roland@redhat.com>,
       Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>,
       Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org
Subject: Re: "build-id" changes break sparc64
Message-ID: <20070723114936.GH21668@ftp.linux.org.uk>
References: <20070723062759.GB3933@uranus.ravnborg.org> <20070723072613.E3A504D0489@magilla.localdomain> <20070723081435.GA4644@uranus.ravnborg.org> <20070723092559.GA24088@bubble.grove.modra.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723092559.GA24088@bubble.grove.modra.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 06:55:59PM +0930, Alan Modra wrote:
> On Mon, Jul 23, 2007 at 10:14:35AM +0200, Sam Ravnborg wrote:
> > But I would still like to hear from Alan what the benefits are.
> 
> See http://sourceware.org/ml/binutils/2004-10/msg00178.html

What does _not_ doing intermediates do to memory footprint of ld(1)
and time spent in there?
