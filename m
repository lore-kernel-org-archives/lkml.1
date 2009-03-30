Return-Path: <linux-kernel-owner+w=401wt.eu-S1757116AbZC3VZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116AbZC3VZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbZC3VYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:24:54 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:47310 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbZC3VYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:24:53 -0400
Date: Mon, 30 Mar 2009 17:20:44 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] slub: scan partial list for free slabs when
 thrashing
In-Reply-To: <alpine.DEB.2.00.0903301317120.21074@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0903301719580.25929@qirst.com>
References: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com> <alpine.DEB.2.00.0903292242510.15813@chino.kir.corp.google.com> <alpine.DEB.2.00.0903292243050.15813@chino.kir.corp.google.com> <alpine.DEB.1.10.0903301033380.13333@qirst.com>
 <alpine.DEB.2.00.0903301317120.21074@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009, David Rientjes wrote:

> Btw, is cl@linux.com your new email address or are all
> linux-foundation.org emails going to eventually migrate to the new domain?

Dont know. I just got the new email address (from the LF) and its shorter
than linux-foundation.org so I started using it.


