Return-Path: <linux-kernel-owner+w=401wt.eu-S1762978AbZFMUOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762978AbZFMUOX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 16:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757905AbZFMUOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 16:14:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38631 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755883AbZFMUOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 16:14:16 -0400
Date: Sat, 13 Jun 2009 13:13:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Paul Mackerras <paulus@samba.org>
cc: benh@kernel.crashing.org, akpm@linux-foundation.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] lib: Provide generic atomic64_t implementation
In-Reply-To: <18995.20685.227683.561827@cargo.ozlabs.ibm.com>
Message-ID: <alpine.LFD.2.01.0906131312470.3237@localhost.localdomain>
References: <18995.20685.227683.561827@cargo.ozlabs.ibm.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 13 Jun 2009, Paul Mackerras wrote:
>
> Linus, Andrew: OK if this goes in via the powerpc tree?

Ok by me.

		Linus
