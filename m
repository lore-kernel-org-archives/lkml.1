Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbYI3CYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbYI3CYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 22:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbYI3CYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 22:24:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752502AbYI3CYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 22:24:32 -0400
Date: Mon, 29 Sep 2008 19:24:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: Dave Airlie <airlied@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jesse.brandeburg@intel.com
Subject: Re: Linux 2.6.27-rc8
In-Reply-To: <alpine.LFD.2.00.0809291921310.3389@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0809291923440.3389@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org> <Pine.LNX.4.64.0809300125460.2307@twin.jikos.cz> <alpine.LFD.2.00.0809291855000.3389@nehalem.linux-foundation.org> <21d7e9970809291859s5bff81e3ue0f63402c2ad422d@mail.gmail.com>
 <20080929190612.111f16ac@infradead.org> <alpine.LFD.2.00.0809291921310.3389@nehalem.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Sep 2008, Linus Torvalds wrote:
> 
> It used to be that you could fry some monitors by feeding them 
> out-of-range signals. The _monitors_ got fixed. 

Mostly. I think you can still do bad things to internal LCD's on at least 
some laptops. Although I hope I'm wrong. 

			Linus
