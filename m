Return-Path: <linux-kernel-owner+w=401wt.eu-S1760040AbXEJUdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760040AbXEJUdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbXEJUdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:33:04 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755479AbXEJUdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:33:01 -0400
Date: Thu, 10 May 2007 13:31:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] ACPI patches for 2.6.22 - part 2
In-Reply-To: <200705100411.32349.lenb@kernel.org>
Message-ID: <alpine.LFD.0.98.0705101330320.3986@woody.linux-foundation.org>
References: <200705100411.32349.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 May 2007, Len Brown wrote:
> 
> Please test this on your Evo before pushing it upstream.

Seems to work for me. My evo correctly started the fan, and stopped it 
when the temperature went down again.

I forget if there were other issues on that machine that some other ACPI 
updates have triggered, but at least there isn't anything *obviously* 
broken on it.

		Linus
