Return-Path: <linux-kernel-owner+w=401wt.eu-S1762263AbYCXSa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762263AbYCXSa0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758333AbYCXSaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:30:12 -0400
Received: from relay1.sgi.com ([192.48.171.29]:52070 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757665AbYCXSaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:30:11 -0400
Date: Mon, 24 Mar 2008 11:28:24 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [04/14] vcompound: Core piece
In-Reply-To: <20080322205729.B317.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0803241127370.3002@schroedinger.engr.sgi.com>
References: <20080321061703.921169367@sgi.com> <20080321061724.956843984@sgi.com>
 <20080322205729.B317.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2008, KOSAKI Motohiro wrote:

> > +struct page *alloc_vcompound_alloc(gfp_t flags, int order);
> 
> where exist alloc_vcompound_alloc?

Duh... alloc_vcompound is not used at this point. Typo. _alloc needs to be 
cut off.

> Hmm,
> IMHO we need vcompound documentation more for the beginner in the Documentation/ directory.
> if not, nobody understand mean of vcompound flag at /proc/vmallocinfo.


Ok.

