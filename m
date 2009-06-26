Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbZFZSgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbZFZSgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 14:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbZFZSgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 14:36:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46462 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280AbZFZSgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 14:36:46 -0400
Message-ID: <4A45027D.3080907@zytor.com>
Date: Fri, 26 Jun 2009 10:16:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Petr Tesarik <ptesarik@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH v3 0/9] clean up vdso-layout.lds.S
References: <1245156929-30395-1-git-send-email-ptesarik@suse.cz> <1246016715.6239.1.camel@nathan.suse.cz>
In-Reply-To: <1246016715.6239.1.camel@nathan.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Tesarik wrote:
> 
> Any plans with this patchset? Is it waiting for somebody's Ack?
> 

Now when the merge window is closed I'm going to review it for .32 most
likely within the next week... I don't think it's super-urgent partly
because it looks to be in good shape.  The fact that I don't consider it
urgent doesn't mean I don't consider it important -- the lack of urgency
is mostly just a matter of when it first showed up in the kernel cycle.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

