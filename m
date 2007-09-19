Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbXISQKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbXISQKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758977AbXISQKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:10:30 -0400
Received: from ns2.suse.de ([195.135.220.15]:43069 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758705AbXISQK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:10:28 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [PATCH] x86: also show non-zero IRQ counts for vectors that currently don't have a handler
Date: Wed, 19 Sep 2007 18:10:24 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <46F15155.76E4.0078.0@novell.com>
In-Reply-To: <46F15155.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709191810.24605.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 September 2007 16:41:57 Jan Beulich wrote:
> It doesn't seem to make sense to hide these, even if their counts
> can't change at the point in time they're being displayed.

Applied thanks

I hope irqbalanced can handle that, but we'll find out.

-Andi
