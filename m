Return-Path: <linux-kernel-owner+w=401wt.eu-S1762359AbXKTUTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762359AbXKTUTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:19:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbXKTUSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:18:54 -0500
Received: from relay1.sgi.com ([192.48.171.29]:36755 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759571AbXKTUSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:18:53 -0500
Date: Tue, 20 Nov 2007 12:18:53 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [rfc 01/45] ACPI: Avoid references to impossible processors.
In-Reply-To: <200711201629.14590.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0711201218310.26419@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <20071120011331.944255657@sgi.com>
 <200711201629.14590.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007, Andi Kleen wrote:

> I would suggest to separate that one and fast-track it, possibly even for 
> 2.6.24

I already did. Andrew has the patch in his tree.
