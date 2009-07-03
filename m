Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbZGCFvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbZGCFvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 01:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbZGCFvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 01:51:24 -0400
Received: from tundra.namei.org ([65.99.196.166]:42030 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbZGCFvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 01:51:24 -0400
Date: Fri, 3 Jul 2009 15:51:26 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
Subject: Re: [PATCH] SElinux: Fix some typos.
In-Reply-To: <4A4D7C94.2020307@gmail.com>
Message-ID: <alpine.LRH.2.00.0907031544160.12340@tundra.namei.org>
References: <1246556775-8942-1-git-send-email-justinmattock@gmail.com> <1246556775-8942-2-git-send-email-justinmattock@gmail.com> <alpine.LRH.2.00.0907030850500.10242@tundra.namei.org> <4A4D7C94.2020307@gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jul 2009, Justin P. Mattock wrote:

> No I will not be afraid of submitting patches, and having them be rejected.
> all part of the learning curve.

I'd suggest generally not starting out with spelling, grammatical and 
formatting patches.  It eats reviewer bandwidth, perturbs the codebase 
(causing people working on it to have to update their code) and does not 
give you as much opportunity to to learn about the code.

Try fixing smaller, known bugs or adding small useful changes.

The TODO list for the SELinux kernel code is here:
http://selinuxproject.org/page/Kernel_Development

You can also email the maintainers and ask for suggestions on what to 
tackle.


- James
-- 
James Morris
<jmorris@namei.org>
