Return-Path: <linux-kernel-owner+w=401wt.eu-S1758451AbYCUPxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758451AbYCUPxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 11:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757085AbYCUPxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 11:53:18 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:53238 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920AbYCUPxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 11:53:17 -0400
To: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: iommu: it could use some documentation
References: <20080319145811.GA27113@elf.ucw.cz>
From: Andi Kleen <andi@firstfloor.org>
Date: 21 Mar 2008 16:53:13 +0100
In-Reply-To: <20080319145811.GA27113@elf.ucw.cz>
Message-ID: <87fxukhy52.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Mar 2008 15:46:37.0351 (UTC) FILETIME=[BF5EBB70:01C88B6A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> Fix coding style in pci-dma_64.c and add stubs for documentation. I
> hope someone fills the rest, I understand maybe off and soft...

The boot options are all documented in
Documentation/x86_64/boot-options.txt, like all other x86-64 specific
boot options.

-Andi
