Return-Path: <linux-kernel-owner+w=401wt.eu-S1760219AbYGQAyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760219AbYGQAyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 20:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbYGQAye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 20:54:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752227AbYGQAye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 20:54:34 -0400
Date: Wed, 16 Jul 2008 17:53:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Please pull ACPI updates
In-Reply-To: <alpine.LFD.1.10.0807161728560.2835@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807161751490.2959@woody.linux-foundation.org>
References: <20080716214516.GA10777@basil.nowhere.org> <200807161633.01375.jbarnes@virtuousgeek.org> <alpine.LFD.1.10.0807161639090.2835@woody.linux-foundation.org> <200807161651.44990.jbarnes@virtuousgeek.org>
 <alpine.LFD.1.10.0807161728560.2835@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jul 2008, Linus Torvalds wrote:
>
> Well, I haven't actually seen Len's original tree, so maybe the stuff Andi 
> pushed was just the stuff he had queued up independently. I guess I 
> shouldn't judge before I'm sure.

No, he rebased it - the three commits you shared are now separate ones. 

Most of the conflicts seem to have been due tot he x86 tree changes 
though. But it seems I didn't mess up too much: at least the result booted 
for me without complaints. So I pushed out my resolution.

Jesse, can you please double-check it?

			Linus
