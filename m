Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbZFEQUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbZFEQUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 12:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZFEQUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 12:20:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55642 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbZFEQUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 12:20:15 -0400
Date: Fri, 5 Jun 2009 18:27:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: clean up vdso-layout.lds.S
Message-ID: <20090605162738.GI1065@one.firstfloor.org>
References: <1243865115.24278.8.camel@nathan.suse.cz> <1244215559.1604.12.camel@nathan.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244215559.1604.12.camel@nathan.suse.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Any comments on this? It doesn't change anything. It only makes it
> harder to break vDSOs by accident (such as the latest buglet with TSC
> synchronization).

Looks ok to me. Although it would have been nicer if you hadn't mixed
that many changes together.

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi

