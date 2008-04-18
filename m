Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbYDRPnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbYDRPnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 11:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbYDRPnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 11:43:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752636AbYDRPni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 11:43:38 -0400
Date: Fri, 18 Apr 2008 08:43:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew <jackdachef@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.25
In-Reply-To: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com>
Message-ID: <alpine.LFD.1.00.0804180843150.2879@woody.linux-foundation.org>
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Apr 2008, Matthew wrote:
> 
> I can "reproduce" this on an Intel Core 2 Duo 6600 (Conroe) with a P5W
> DH Deluxe mainboard (by Asus) since at least 2.6.25-rc8 (or possibly
> also rc7)

Can you bisect it? 

		Linus
