Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbYH2Uwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbYH2Uwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 16:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbYH2Uwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 16:52:37 -0400
Received: from 1wt.eu ([62.212.114.60]:3082 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177AbYH2Uwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 16:52:37 -0400
Date: Fri, 29 Aug 2008 22:51:41 +0200
From: Willy Tarreau <w@1wt.eu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Marcel Holtmann <holtmann@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>,
       bgmerrell@novell.com, hirofuchi@users.sourceforge.net,
       linux-kernel@vger.kernel.org, usbip-devel@lists.sourceforge.net
Subject: Re: USBIP protocol
Message-ID: <20080829205141.GE19337@1wt.eu>
References: <20080829140224.GC1968@parisc-linux.org> <87ej47q5k8.fsf@basil.nowhere.org> <1220049103.7145.23.camel@californication> <20080829204627.GB1239@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080829204627.GB1239@parisc-linux.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 02:46:27PM -0600, Matthew Wilcox wrote:
> On Sat, Aug 30, 2008 at 12:31:43AM +0200, Marcel Holtmann wrote:
(...)
> > I would also have proposed SCTP. The telco carries seems be very happy
> > with it.
> 
> I'm actually looking into the sunrpc protocol.  That has the advantages:
>  - Already has an in-kernel implementation
>  - Widely understood and properly documented
>  - Can be run over TCP or UDP or even RDMA

and :
   - already supported by most firewalls.

Willy

