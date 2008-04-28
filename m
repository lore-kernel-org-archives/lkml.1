Return-Path: <linux-kernel-owner+w=401wt.eu-S1765416AbYD1GSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765416AbYD1GSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbYD1GSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:18:31 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:40531 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750898AbYD1GSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:18:30 -0400
Date: Mon, 28 Apr 2008 02:18:26 -0400 (EDT)
From: Jeff Arnold <jbarnold@MIT.EDU>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: A system for rebootless kernel security updates
In-Reply-To: <87r6cvgyi1.fsf@basil.nowhere.org>
Message-ID: <alpine.DEB.1.10.0804280119001.9237@vinegar-pot.mit.edu>
References: <alpine.DEB.1.00.0802221606520.21343@vinegar-pot.mit.edu> <87r6cvgyi1.fsf@basil.nowhere.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You should consider bringing the kernel module up to kernel coding 
> standards and submitting it for mainline. That would be the best way to 
> get more users and testers.

I'm certainly interested in bringing the code up to kernel coding 
standards (for example, I'd be happy to address any issues with the code 
that are brought to my attention).  I'm not sure whether submitting it for 
mainline makes sense since the software doesn't significantly benefit from 
being bundled with the kernel.

Instead, it might be more important to 1) package the userspace 
update-construction software for common Linux distributions to make it 
easily available to interested users, and 2) to provide binary kernel 
updates for common distribution kernels so that users can simply sign up 
and get fewer "your machine needs to be rebooted now for an update to take 
effect" notifications.

I'm open to suggestions about how I should proceed, however.

> Have you also considered to turn it into a generic incremental binary
> linker too?

I've considered modifying the system for use in other contexts, but I 
don't think that I'll get around to such a project anytime soon; my 
current focus is on making it easier for people to perform rebootless 
kernel security updates.

Jeff Arnold
jbarnold@mit.edu
