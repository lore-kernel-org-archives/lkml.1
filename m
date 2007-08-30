Return-Path: <linux-kernel-owner+w=401wt.eu-S932815AbXH3RWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815AbXH3RWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 13:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932329AbXH3RWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 13:22:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55493 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757667AbXH3RWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 13:22:22 -0400
Date: Thu, 30 Aug 2007 10:21:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
cc: Luca Tettamanti <kronos.it@gmail.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.23-rc4: BAD regression
In-Reply-To: <200708301907.56561.daniel.ritz-ml@swissonline.ch>
Message-ID: <alpine.LFD.0.999.0708301020410.25853@woody.linux-foundation.org>
References: <200708290129.57243.daniel.ritz-ml@swissonline.ch>
 <20070829232150.GA17467@dreamland.darkstar.lan>
 <200708301907.56561.daniel.ritz-ml@swissonline.ch>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 30 Aug 2007, Daniel Ritz wrote:
> 
> i've just tested the minimal fix here:
> 	http://bugzilla.kernel.org/show_bug.cgi?id=8958#c7
> works good so far. fan starts and system is responsive.

Alexey, Len, can we get this fix integrated asap?

		Linus
