Return-Path: <linux-kernel-owner+w=401wt.eu-S1758759AbYD3PvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759AbYD3PvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 11:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757793AbYD3PvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 11:51:11 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:26228 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757710AbYD3PvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 11:51:10 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: RFC: make MAINTAINERS email addresses easier to copy/paste
Date: Wed, 30 Apr 2008 09:51:10 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <200804291459.56300.bjorn.helgaas@hp.com> <20080430084938.GA31984@infradead.org>
In-Reply-To: <20080430084938.GA31984@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804300951.10645.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 April 2008 02:49:38 am Christoph Hellwig wrote:
> On Tue, Apr 29, 2008 at 02:59:56PM -0600, Bjorn Helgaas wrote:
> > The current MAINTAINERS file format makes it a nuisance to
> > copy both the display name and the actual address.  So
> > I propose that we fold together the current "P:" and "M:"
> > lines using something similar to the filter below.
> 
> Why do you want to copy the real name?  It's entirely superflous for
> mail routing.

Sure, it's superfluous, but I think it's nice to use the name
when I can.  Probably for the same reason you include "Christoph
Hellwig" in your "From:" header :-)
