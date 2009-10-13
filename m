Return-Path: <linux-kernel-owner+w=401wt.eu-S1760410AbZJMPxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760410AbZJMPxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbZJMPxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:53:44 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:49097 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753317AbZJMPxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:53:44 -0400
Date: Tue, 13 Oct 2009 11:45:44 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mel@csn.ul.ie>
cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [this_cpu_xx V6 0/7] Introduce per cpu atomic operations and
 avoid per cpu address arithmetic
In-Reply-To: <20091013154020.GA18716@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0910131145150.9478@gentwo.org>
References: <20091007211024.442168959@gentwo.org> <20091013154020.GA18716@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Mel Gorman wrote:

> FWIW, this fails to boot on latest mmotm on x86-64 even though the patches
> apply. It fails to create basic slab cackes like kmalloc-64.

There was a fixup patch for one of the slub patches. Was that merged?

