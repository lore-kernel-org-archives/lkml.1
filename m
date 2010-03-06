Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab0CFTax (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 14:30:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604Ab0CFTaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 14:30:52 -0500
Date: Sat, 6 Mar 2010 11:28:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Sergio Monteiro Basto <sergio@sergiomb.no-ip.org>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
In-Reply-To: <1267902406.24025.50.camel@segulix>
Message-ID: <alpine.LFD.2.00.1003061127060.31447@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>  <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>  <alpine.LFD.2.00.1003041035380.3751@localhost.localdomain>  <1267889034.24025.4.camel@segulix>  <alpine.LFD.2.00.1003060937370.31447@localhost.localdomain>
 <1267902406.24025.50.camel@segulix>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 6 Mar 2010, Sergio Monteiro Basto wrote:

> On Sat, 2010-03-06 at 09:40 -0800, Linus Torvalds wrote:
> > Why are people making excuses for bad programming and bad technology?
> 
> Is not bad technology is new technology, the API have to change faster ,
> unless you want wait 2 years until get "stable" .  

F*ck me, but people are being dense.

With my suggestion, people could change the API _more_, because it 
wouldn't be as painful.

This is not about "change the ABI or not". This is about "since you change 
the ABI, do it _well_, so that it doesn't hurt people as much".

		Linus
