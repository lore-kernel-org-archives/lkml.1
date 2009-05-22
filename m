Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbZEVU2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbZEVU2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 16:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757454AbZEVU2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 16:28:44 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:56447 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757580AbZEVU2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 16:28:43 -0400
Date: Fri, 22 May 2009 15:44:37 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Pavel Machek <pavel@ucw.cz>, Dave Hansen <dave@linux.vnet.ibm.com>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Misleading OOM messages
In-Reply-To: <4A16FFA7.5010005@oracle.com>
Message-ID: <alpine.DEB.1.10.0905221543390.9506@qirst.com>
References: <1242333519.15391.210.camel@nimitz> <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com> <1242335120.15391.242.camel@nimitz> <alpine.DEB.1.10.0905141729180.30187@qirst.com> <20090514213403.GB14741@elf.ucw.cz> <1242337299.28440.47.camel@nimitz>
 <20090515130547.GA1976@elf.ucw.cz> <alpine.DEB.1.10.0905151358430.26559@qirst.com> <20090515200213.GA1406@ucw.cz> <alpine.DEB.1.10.0905151713230.26489@qirst.com> <20090519203944.GD1362@ucw.cz> <alpine.DEB.1.10.0905221500390.5204@qirst.com>
 <4A16FFA7.5010005@oracle.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009, Randy Dunlap wrote:

> But I think that normal users won't know what reclaiming memory is anyway,
> so the patch doesn't help IMO.

If they dont know then they may ask someone who knows and/or report a bug.

