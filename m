Return-Path: <linux-kernel-owner+w=401wt.eu-S1759382AbXK0SRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbXK0SRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 13:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbXK0SRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 13:17:15 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45069 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756051AbXK0SRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 13:17:14 -0500
Date: Tue, 27 Nov 2007 10:17:14 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andreas Schwab <schwab@suse.de>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, tony.luck@intel.com
Subject: Re: [patch 04/14] ia64: Remove the __SMALL_ADDR_AREA attribute for
 per cpu access
In-Reply-To: <jehcj83uir.fsf@sykes.suse.de>
Message-ID: <Pine.LNX.4.64.0711271016500.2310@schroedinger.engr.sgi.com>
References: <20071127001407.859743255@sgi.com> <20071127001430.083503280@sgi.com>
 <jehcj83uir.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007, Andreas Schwab wrote:

> Christoph Lameter <clameter@sgi.com> writes:
> 
> > The model(small) attribute is not supported by gcc 4.X.
> 
> Which gcc 4.X are you talking about?

All. Last gcc that supported this was 3.4.

