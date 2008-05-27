Return-Path: <linux-kernel-owner+w=401wt.eu-S1759311AbYE0RDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311AbYE0RDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 13:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758076AbYE0RDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 13:03:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757971AbYE0RDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 13:03:39 -0400
Date: Tue, 27 May 2008 13:03:25 -0400
From: Rik van Riel <riel@redhat.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH -mm 02/16] Use an indexed array for LRU variables
Message-ID: <20080527130325.457b2697@cuia.bos.redhat.com>
In-Reply-To: <1211907262.7283.30.camel@lts-notebook>
References: <20080523195506.084894989@redhat.com>
	<20080523195534.918991067@redhat.com>
	<1211907262.7283.30.camel@lts-notebook>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 12:54:22 -0400
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> > Index: linux-2.6.26-rc2-mm1/include/linux/mm_inline.h
> > ===================================================================
> > --- linux-2.6.26-rc2-mm1.orig/include/linux/mm_inline.h	2008-05-23 14:21:21.000000000 -0400
> > +++ linux-2.6.26-rc2-mm1/include/linux/mm_inline.h	2008-05-23 14:21:33
> > 
> 
> Rik:  looks like this patch got truncated somewhere along the way.

Ohhh, so that's why formail initially stopped after mailing out this
patch and I had to restart it from the 3rd message!  I didn't get any
NFS IO errors, so I guess it just got an EOF :(

I've just resent patch 02/16.

-- 
All Rights Reversed
