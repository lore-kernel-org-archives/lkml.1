Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbZLBXqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbZLBXqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 18:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbZLBXqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 18:46:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753291AbZLBXqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 18:46:43 -0500
Date: Wed, 2 Dec 2009 15:46:08 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ralf Baechle <ralf@linux-mips.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Pull request for MIPS-specific driver bits
In-Reply-To: <20091201174612.GA18799@linux-mips.org>
Message-ID: <alpine.LFD.2.00.0912021543440.2872@localhost.localdomain>
References: <20091201174612.GA18799@linux-mips.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Dec 2009, Ralf Baechle wrote:
> 
> Please pull them from
> 
>     git://ftp.linux-mips.org/pub/scm/upstream-linus.git upstream

There are no driver updates there. It looks like you overwrote that branch 
with your other MIPS build fixes that you had a separate pull request for.

			Linus
