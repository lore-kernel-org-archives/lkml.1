Return-Path: <linux-kernel-owner+w=401wt.eu-S932155AbZKRWN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbZKRWN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757121AbZKRWN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:13:27 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33835 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbZKRWN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:13:26 -0500
Date: Wed, 18 Nov 2009 17:13:31 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org
Subject: Re: [patch 07/13] parisc: Fixup last users of irq_chip->typename
Message-ID: <20091118221330.GF28962@bombadil.infradead.org>
References: <20091117224852.846805939@linutronix.de> <20091117224916.604120310@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117224916.604120310@linutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 10:50:59PM -0000, Thomas Gleixner wrote:
> The typename member of struct irq_chip was kept for migration purposes
> and is obsolete since more than 2 years. Fix up the leftovers.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Kyle McMartin <kyle@mcmartin.ca>
> Cc: linux-parisc@vger.kernel.org

Thanks, applied.
