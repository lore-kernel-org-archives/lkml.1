Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbYIDMox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbYIDMox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 08:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbYIDMop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 08:44:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:43551 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbYIDMop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 08:44:45 -0400
Date: Thu, 4 Sep 2008 05:44:44 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de, hpa@zytor.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
Message-ID: <20080904054444.79e71974@infradead.org>
In-Reply-To: <873akgw251.fsf@basil.nowhere.org>
References: <20080903195122.73905236@infradead.org>
	<873akgw251.fsf@basil.nowhere.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Sep 2008 14:01:46 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Arjan van de Ven <arjan@infradead.org> writes:
> 
> > Add basic sanity checks to the syscall execution patch
> 
> This just means that the root kits will switch to patch
> the first instruction of the entry points instead.
> 
> So the protection will be zero to minimal, but the overhead will
> be there forever.
> 
> Now that I said this I expect it to go in yesterday.
>

I'd have considered taking your email serious if you had left out the
uncalled and unneeded sarcasm line at the end.



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
