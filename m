Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab0CHP7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 10:59:40 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:55025 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab0CHP7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 10:59:37 -0500
Date: Mon, 8 Mar 2010 09:59:26 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: mm: Do not iterate over NR_CPUS in __zone_pcp_update()
In-Reply-To: <alpine.LFD.2.00.1003081018070.22855@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1003080959150.413@router.home>
References: <alpine.LFD.2.00.1003081018070.22855@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Christoph Lameter <cl@linux-foundation.org>


