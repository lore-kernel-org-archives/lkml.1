Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab0CFBfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 20:35:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60194 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab0CFBfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 20:35:52 -0500
Date: Fri, 5 Mar 2010 20:35:50 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Christian Ehrhardt <lk@c--e.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] rmap: Fix Bugzilla Bug #5493
Message-ID: <20100306013550.GI12443@bombadil.infradead.org>
References: <20100305093834.GG17078@lisa.in-ulm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100305093834.GG17078@lisa.in-ulm.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 10:38:35AM +0100, Christian Ehrhardt wrote:
> NOTE: This needs an Ack from someone who can compile on arm and parisc.
> 

Compiles fine for me. Thanks for asking!

parisc bits are Acked-by: Kyle McMartin <kyle@mcmartin.ca>

regards, Kyle
