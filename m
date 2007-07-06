Return-Path: <linux-kernel-owner+w=401wt.eu-S1763884AbXGFPx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763884AbXGFPx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 11:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761385AbXGFPxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 11:53:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564AbXGFPxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 11:53:18 -0400
Date: Fri, 6 Jul 2007 16:53:12 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Bodo Eggert <7eggert@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: shouldn't LVM support be selected by default?
Message-ID: <20070706155312.GB12786@agk.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Bodo Eggert <7eggert@gmx.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <8CNXF-47r-3@gated-at.bofh.it> <E1I5htd-0000ix-SE@be1.lrz> <Pine.LNX.4.64.0707030913380.21919@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707030913380.21919@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 09:13:54AM -0400, Robert P. J. Day wrote:
> On Tue, 3 Jul 2007, Bodo Eggert wrote:
> > If you don't know about LVM, you don't need it. Do you?
> well, ok, i can go with that.  thanks.
 
But we should probably drop EXPERIMENTAL now from more of the targets.

Alasdair
-- 
agk@redhat.com
