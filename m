Return-Path: <linux-kernel-owner+w=401wt.eu-S1765006AbYCEJsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765006AbYCEJsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 04:48:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764340AbYCEJrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 04:47:45 -0500
Received: from relay1.sgi.com ([192.48.171.29]:59202 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758175AbYCEJro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 04:47:44 -0500
Date: Wed, 5 Mar 2008 03:47:37 -0600
From: Robin Holt <holt@sgi.com>
To: Avi Kivity <avi@qumranet.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>,
       Andrea Arcangeli <andrea@qumranet.com>, Jack Steiner <steiner@sgi.com>,
       Nick Piggin <npiggin@suse.de>, akpm@linux-foundation.org,
       Robin Holt <holt@sgi.com>, kvm-devel@lists.sourceforge.net,
       general@lists.openfabrics.org, Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [RFC] Notifier for Externally Mapped Memory (EMM)
Message-ID: <20080305094736.GA2013@sgi.com>
References: <20080303213707.GA8091@v2.random> <20080303220502.GA5301@v2.random> <47CC9B57.5050402@qumranet.com> <Pine.LNX.4.64.0803032327470.9642@schroedinger.engr.sgi.com> <20080304133020.GC5301@v2.random> <Pine.LNX.4.64.0803041059110.13957@schroedinger.engr.sgi.com> <20080304222030.GB8951@v2.random> <Pine.LNX.4.64.0803041422070.20821@schroedinger.engr.sgi.com> <1204670529.6241.52.camel@lappy> <47CE2B23.6010505@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CE2B23.6010505@qumranet.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 07:09:55AM +0200, Avi Kivity wrote:
> Isn't that out of the question for .25?

I keep hearing this mantra.  What is so compelling about the .25
release?  When seems to be more important than what.  While I understand
product release cycles, etc. and can certainly agree with them. I would
like to know with what I am being asked to agree.

That said, I agree we should probably finish getting the comments on
Andrea's most recent patch, if any, cleared up and put that one in.

Robin
