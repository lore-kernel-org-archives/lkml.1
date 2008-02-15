Return-Path: <linux-kernel-owner+w=401wt.eu-S932772AbYBOLML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772AbYBOLML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 06:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbYBOLL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 06:11:59 -0500
Received: from ns.suse.de ([195.135.220.2]:53155 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbYBOLL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 06:11:58 -0500
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] x86: validate against acpi motherboard resources
From: Andi Kleen <andi@firstfloor.org>
References: <200802150127.21247.yinghai.lu@sun.com>
Date: Fri, 15 Feb 2008 12:11:57 +0100
In-Reply-To: <200802150127.21247.yinghai.lu@sun.com> (Yinghai Lu's message of "Fri\, 15 Feb 2008 01\:27\:20 -0800")
Message-ID: <p7363wq1nk2.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <Yinghai.Lu@Sun.COM> writes:
>
> [akpm@linux-foundation.org: many fixes and cleanups]
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>
> Signed-off-by: Andi Kleen <ak@suse.de>
> Tested-by: Andi Kleen <ak@suse.de>

iirc it really was 
Tested-and-didnt-pass-test-by: Andi Kleen 
unfortunately. I have not rechecked recently, but on the one Intel
box the original patch and the other mcfg heuristics removed didn't work.

-Andi
