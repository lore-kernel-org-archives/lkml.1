Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbYCYKGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbYCYKGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 06:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYCYKGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 06:06:40 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:43035 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbYCYKGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 06:06:39 -0400
To: Jack Steiner <steiner@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 5/8] x86_64: Add UV specific header for MMR definitions
References: <20080324182116.GA28285@sgi.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 25 Mar 2008 11:06:37 +0100
In-Reply-To: <20080324182116.GA28285@sgi.com>
Message-ID: <87iqzbi0cy.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Mar 2008 09:59:59.0676 (UTC) FILETIME=[FCA45FC0:01C88E5E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Steiner <steiner@sgi.com> writes:

> 
> 	Signed-off-by: Jack Steiner <steiner@sgi.com>

Not sure why you indent that? Normally it is not. 
Some tools get confused by it I think.

> ---
>  include/asm-x86/uv_mmrs.h |  373 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 373 insertions(+)
> 
> Index: linux/include/asm-x86/uv_mmrs.h

I personally would consider it cleaner to put these into a asm-x86/uv/ 
sub directory

-Andi

