Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039Ab0ARLP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab0ARLP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 06:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620Ab0ARLP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 06:15:27 -0500
Received: from cantor.suse.de ([195.135.220.2]:51266 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab0ARLP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 06:15:26 -0500
Message-ID: <4B5442CC.8050200@suse.cz>
Date: Mon, 18 Jan 2010 12:15:24 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] kbuild: improve version string logic
References: <alpine.DEB.2.00.1001041330230.26148@chino.kir.corp.google.com> <4B4345AF.9040600@suse.cz> <alpine.DEB.2.00.1001131300360.26527@chino.kir.corp.google.com> <20100116063754.GC20342@elte.hu> <20100116183445.29fc5d50.sfr@canb.auug.org.au> <20100116092658.GA23999@elte.hu> <4B542C99.9000801@suse.cz> <alpine.DEB.2.00.1001180243300.20677@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1001180243300.20677@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.1.2010 11:45, David Rientjes wrote:
> Michal, where are you hosting your git tree?  Are you going to be taking 
> over kbuild-next on git.kernel.org?

git://repo.or.cz/linux-kbuild.git for-next
(http://repo.or.cz/w/linux-kbuild.git). Maybe I should ask for an
account in git.kernel.org account and move it there, you're not the
first one to wonder where to find the tree :).

Michal
