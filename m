Return-Path: <linux-kernel-owner+w=401wt.eu-S1759073AbXLSAmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759073AbXLSAmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 19:42:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbXLSAmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 19:42:17 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:36031 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbXLSAmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 19:42:16 -0500
Date: Wed, 19 Dec 2007 00:30:28 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Rohland <hans-christoph.rohland@sap.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] tmpfs: allow filepage alongside swappage 
In-Reply-To: <200712182251.lBIMpUbp030364@agora.fsl.cs.sunysb.edu>
Message-ID: <Pine.LNX.4.64.0712190027560.5639@blonde.wat.veritas.com>
References: <200712182251.lBIMpUbp030364@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2007, Erez Zadok wrote:
> 
> Just curious, but didn't you (or someone else) mention that they wanted to
> do away with AOP_WRITEPAGE_ACTIVATE entirely?  If these patches are for
> 2.6.25, would that be the right time?

That's right, it was me.  Not forgotten, but I was anxious to complete
this set of fixes, before going back to that cleanup.  When I've a moment.

Hugh
