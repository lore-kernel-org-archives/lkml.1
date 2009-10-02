Return-Path: <linux-kernel-owner+w=401wt.eu-S1756954AbZJBQnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954AbZJBQnH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 12:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756691AbZJBQnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 12:43:07 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:33096 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689AbZJBQnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 12:43:06 -0400
Message-ID: <4AC62C8C.4060906@csr.com>
Date: Fri, 02 Oct 2009 17:38:36 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [109/136] USB: xhci: Make TRB completion code comparison readable.
References: <20091002011548.335611824@mini.kroah.org> <20091002012424.339883108@mini.kroah.org>
In-Reply-To: <20091002012424.339883108@mini.kroah.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Oct 2009 16:38:37.0179 (UTC) FILETIME=[CA42B4B0:01CA437E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> 2.6.31-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> 
> commit 66d1eebce5cca916e0b08d961690bb01c64751ef upstream.
> 
> Use trb_comp_code instead of getting the completion code from the transfer
> event every time.

Are all these xhci patches really candidates for the stable tree?  XHCI
support is marked as EXPERIMENTAL, the xhci standard is still at the
draft stage, and I don't believe there are any xhci products available
on the market yet.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
