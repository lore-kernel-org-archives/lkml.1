Return-Path: <linux-kernel-owner+w=401wt.eu-S1751899AbZFKVVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbZFKVVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 17:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbZFKVVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 17:21:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58362 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbZFKVVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 17:21:36 -0400
Date: Thu, 11 Jun 2009 14:21:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Catalin Marinas <catalin.marinas@arm.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kmemleak: Pull request
In-Reply-To: <1244737527.13225.69.camel@pc1117.cambridge.arm.com>
Message-ID: <alpine.LFD.2.01.0906111420430.3535@localhost.localdomain>
References: <1244737527.13225.69.camel@pc1117.cambridge.arm.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Jun 2009, Catalin Marinas wrote:
> 
> Please consider pulling the kmemleak patches from the branch detailed
> below.

Ok, I got conflicts with the slab/earlyboot changes, but they looked 
resolvable. I haven't tested the merge though, so please do give it a good 
check.

		Linus
