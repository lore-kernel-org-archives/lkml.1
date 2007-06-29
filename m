Return-Path: <linux-kernel-owner+w=401wt.eu-S932543AbXF2Gvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbXF2Gvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 02:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756183AbXF2Gvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 02:51:42 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45748 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752756AbXF2Gvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 02:51:42 -0400
Date: Thu, 28 Jun 2007 23:51:41 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Miller <davem@davemloft.net>, hugh@veritas.com,
       James.Bottomley@steeleye.com, rmk+lkml@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Containment measures for slab objects on scatter gather
 lists
In-Reply-To: <20070628224519.1a3319c3.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706282351100.12146@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706282128570.11739@schroedinger.engr.sgi.com>
 <20070628.220606.112621271.davem@davemloft.net> <20070628222424.4cbae90c.akpm@linux-foundation.org>
 <20070628.223734.21928089.davem@davemloft.net> <20070628224519.1a3319c3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007, Andrew Morton wrote:

> If those operations _don't_ involve modifying the pageframe (hopes this is
> true) then we're read-only and things become much easier?

This is true right now. We are way off topic ...

