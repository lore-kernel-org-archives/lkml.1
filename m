Return-Path: <linux-kernel-owner+w=401wt.eu-S1759847AbYDCTEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759847AbYDCTEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755617AbYDCTED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:04:03 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:43848 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbYDCTEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:04:01 -0400
Date: Thu, 3 Apr 2008 16:04:00 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] SLQB: YASA
Message-ID: <20080403160400.311ab5af@mandriva.com.br>
In-Reply-To: <20080403142326.GA9878@wotan.suse.de>
References: <20080403072550.GC25932@wotan.suse.de>
	<20080403142326.GA9878@wotan.suse.de>
Organization: Mandriva
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 3 Apr 2008 16:23:26 +0200
Nick Piggin <npiggin@suse.de> escreveu:

| On Thu, Apr 03, 2008 at 09:25:50AM +0200, Nick Piggin wrote:
| > Hi,
| > 
| > I've been playing around with slab allocators because I'm concerned about
| > the directions that SLUB is going in. I've come up so far with a working
| > alternative implementation, which I have called SLQB (the remaining vowels
| > are crap).
| 
| Oh, hmm, I think I messed up a hunk when merging in a patch here... so
| this version is going to be buggy. I'll repost another tomorrow, so
| nobody try to test this yet :)

 Thanks for letting us know, I was trying to merge this.

 Would be nice if you say for what kernel the patch is for,
normally I assume Linus' latest but sometimes patches are
against -mm.

-- 
Luiz Fernando N. Capitulino
