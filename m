Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbZCKTUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbZCKTUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 15:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754338AbZCKTUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 15:20:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53353 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753474AbZCKTUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 15:20:39 -0400
Date: Wed, 11 Mar 2009 12:18:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: [git pull] Please pull powerpc.git merge branch
In-Reply-To: <alpine.LRH.2.00.0903111652070.1040@vixen.sonytel.be>
Message-ID: <alpine.LFD.2.00.0903111217320.32478@localhost.localdomain>
References: <1236729444.7086.24.camel@pasglop> <alpine.LRH.2.00.0903111028480.1040@vixen.sonytel.be> <1236769025.7086.46.camel@pasglop> <alpine.LFD.2.00.0903110835020.32478@localhost.localdomain> <alpine.LRH.2.00.0903111652070.1040@vixen.sonytel.be>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Mar 2009, Geert Uytterhoeven wrote:
> 
> Are you aware the old one was introduced in 2.6.29-rc1? So there cannot be a
> regression from 2.6.28 or older.

Ahh, no, that part hadn't registered.

In that case, I guess I don't really care, as long as everybody involved 
feels it's clearly better than the one merged into -rc1.

		Linus
