Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZFQPhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZFQPhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 11:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZFQPha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 11:37:30 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54774 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbZFQPha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 11:37:30 -0400
Subject: Re: [PATCH] kmemleak: Rename kmemleak_panic to kmemleak_stop
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <1245253019.11889.55.camel@pc1117.cambridge.arm.com>
References: <200906162232.n5GMWRZe026963@imap1.linux-foundation.org>
	 <20090616223649.719ea378.akpm@linux-foundation.org>
	 <20090617111800.GA15261@elte.hu> <20090617113120.GA5061@elte.hu>
	 <1245240677.11889.17.camel@pc1117.cambridge.arm.com>
	 <20090617122803.GD28529@csn.ul.ie>
	 <1245242160.11889.23.camel@pc1117.cambridge.arm.com>
	 <20090617124034.GE28529@csn.ul.ie>
	 <1245243130.11889.27.camel@pc1117.cambridge.arm.com>
	 <84144f020906170601l254d3b29udc688d02426ea247@mail.gmail.com>
	 <1245245007.11889.42.camel@pc1117.cambridge.arm.com>
	 <1245245448.5604.31.camel@penberg-laptop>
	 <1245253019.11889.55.camel@pc1117.cambridge.arm.com>
Date: Wed, 17 Jun 2009 18:37:31 +0300
Message-Id: <1245253051.20623.0.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 16:36 +0100, Catalin Marinas wrote:
> This is to avoid the confusion created by the "panic" word.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

