Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbYCBVQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbYCBVQS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 16:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbYCBVQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 16:16:03 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:33215 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101AbYCBVQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 16:16:02 -0500
Date: Sun, 2 Mar 2008 22:15:59 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel-doc: set verbose mode via environment
In-Reply-To: <20080228160920.c66c7b88.randy.dunlap@oracle.com>
Message-ID: <alpine.DEB.1.00.0803022214180.6469@sheep.housecafe.de>
References: <20080224175358.3202f0d0.randy.dunlap@oracle.com> <20080227191104.6f166972.akpm@linux-foundation.org> <20080228083009.5955a7eb.randy.dunlap@oracle.com> <20080228183234.GA24684@uranus.ravnborg.org>
 <20080228160920.c66c7b88.randy.dunlap@oracle.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Randy Dunlap wrote:
>>> I did think about that.  I was still wondering where to add it.
>> In the same file where you document all the kconfig stuff - so we can let it be
>> a 'all build features ' document?
>
> Which "same file" is that?

Hm, what about ./README (which already lists a few make targets) or 
./Makefile so it's displayed when doing "make help"?

C.
-- 
BOFH excuse #13:

we're waiting for [the phone company] to fix that line
