Return-Path: <linux-kernel-owner+w=401wt.eu-S1767479AbXDFBcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767479AbXDFBcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 21:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767469AbXDFBcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 21:32:15 -0400
Received: from gw.goop.org ([64.81.55.164]:45917 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767479AbXDFBcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 21:32:14 -0400
Message-ID: <4615A2F8.7040602@goop.org>
Date: Thu, 05 Apr 2007 18:31:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Bugfix for VMI paravirt ops
References: <46158674.5090709@vmware.com> <200704060154.41574.ak@suse.de> <46158DE1.4050508@vmware.com> <46158F8E.1050807@goop.org> <46158FBE.3090105@vmware.com> <461590EA.10605@goop.org> <4615924E.8020009@vmware.com> <46159555.4020706@goop.org> <4615982A.1070700@vmware.com> <461599C1.50002@goop.org> <46159A2A.8050804@vmware.com>
In-Reply-To: <46159A2A.8050804@vmware.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Throw it in the queue; I'll slide in after it.

I've pushed it up.  I added a few missing cases to the patch
(kmap_atomic_pte, kunmap_atomic).

    J
