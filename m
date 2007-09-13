Return-Path: <linux-kernel-owner+w=401wt.eu-S1765208AbXIMSja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765208AbXIMSja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 14:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbXIMSjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 14:39:22 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:45854 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbXIMSjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 14:39:21 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 13 Sep 2007 14:37:11 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
cc: Chris Wedgwood <cw@f00f.org>, LKML <linux-kernel@vger.kernel.org>,
       davej@redhat.com, Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [RFC PATCH] Add a 'minimal tree install' target
In-Reply-To: <20070913183359.GA27146@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0709131435001.6921@localhost.localdomain>
References: <20070912232534.GA26868@puku.stupidest.org>
 <20070913183359.GA27146@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	TW_VN 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2007, Sam Ravnborg wrote:

> Hi Chris.
>
> On Wed, Sep 12, 2007 at 04:25:34PM -0700, Chris Wedgwood wrote:
...
> > -----
> > Add a 'mintree-install' makefile target.

> I would strongly prefer the name "build-pkg".

what about "devel-pkg" instead?  that would match fedora's
"kernel-devel" naming convention.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
