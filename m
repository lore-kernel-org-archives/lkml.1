Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbXE3PG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbXE3PG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 11:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbXE3PGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 11:06:03 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752767AbXE3PGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 11:06:02 -0400
Date: Wed, 30 May 2007 08:05:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Robert Hancock <hancockr@shaw.ca>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH -mm] 1/2: MMCONFIG: validate against ACPI motherboard
 resources
In-Reply-To: <465D8BA1.1080800@shaw.ca>
Message-ID: <alpine.LFD.0.98.0705300804140.26602@woody.linux-foundation.org>
References: <465CF794.1070406@shaw.ca> <alpine.LFD.0.98.0705292125511.26602@woody.linux-foundation.org>
 <465D8BA1.1080800@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 May 2007, Robert Hancock wrote:
> 
> I'll try and fix up the formatting and repost this patch.

Thanks.

>							 I suspect some
> of the issues are from the added code clashing with the way the existing
> code was formatted.

Well, I have to admit that I might not have reacted so much if it hadn't 
been for the Thunderbird thing, which made it look _really_ strange at 
first, so then I had to go outside my mail client to look closer. And once 
I looked closer, I just went "aiieee, it wasn't all the email client" ;)

		Linus
