Return-Path: <linux-kernel-owner+w=401wt.eu-S932226AbXIKSb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbXIKSb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 14:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762392AbXIKSbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 14:31:17 -0400
Received: from relais.videotron.ca ([24.201.245.36]:33317 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762262AbXIKSbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:31:16 -0400
Date: Tue, 11 Sep 2007 14:31:16 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
Subject: Re: [PATCH/RFC] doc: about email clients for Linux kernel patches
In-reply-to: <20070911181700.GP3563@stusta.de>
X-X-Sender: nico@xanadu.home
To: Adrian Bunk <bunk@kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       jgarzik <jgarzik@pobox.com>
Message-id: <alpine.LFD.0.9999.0709111428490.21186@xanadu.home>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Content-transfer-encoding: 7BIT
References: <20070911101644.cd3f641f.randy.dunlap@oracle.com>
 <alpine.LFD.0.9999.0709111333050.21186@xanadu.home>
 <20070911181700.GP3563@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007, Adrian Bunk wrote:

> On Tue, Sep 11, 2007 at 02:03:34PM -0400, Nicolas Pitre wrote:
> > On Tue, 11 Sep 2007, Randy Dunlap wrote:
> >...
> > > +Alpine (TUI)
> > > +
> > > +<I don't know.  Maybe Adrian or Linus can comment.>
> > > +
> > > +Are any special config options needed?
> > 
> > Alpine is the successor of Pine.  Issues that were found in some earlier 
> > Pine versions wrt patch sending are now fixed.
> >...
> 
> There were no problems with sending patches in pine.

One old version did have problems with spaces at the end of lines 
despite the config option, and you had to manually patch it if your 
distro didn't.


Nicolas
