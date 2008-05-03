Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbYECXjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbYECXjZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 19:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbYECXjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 19:39:17 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:56658 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889AbYECXjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 19:39:16 -0400
Date: Sun, 4 May 2008 02:38:18 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Justin Mattock <justinmattock@gmail.com>
Cc: npiggin@suse.de, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: nopage mm.h
Message-ID: <20080503233818.GZ5838@cs181133002.pp.htv.fi>
References: <dd18b0c30805031629x5f570b97q43f110b228054a28@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dd18b0c30805031629x5f570b97q43f110b228054a28@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 11:29:20PM +0000, Justin Mattock wrote:
> Hello; I have a question about the nopage function that was removed in
> the kernel.
> What would be the best way for me to build a module that has a nopage
> funtion in it?
> Right now I went and undid what you had done to the kernel,to atleast
> have the module not give me errors,
> but, am wondering if I should try to take the module and remove the
> nopage function in it , and add the functions that is relevent.
> to keep the module up-to date.

Where can we find the source code of your module?

> regards;

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

