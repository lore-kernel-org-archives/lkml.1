Return-Path: <linux-kernel-owner+w=401wt.eu-S1762715AbZE0MAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762715AbZE0MAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 08:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758878AbZE0MAD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 08:00:03 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:65296 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756999AbZE0MAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 08:00:01 -0400
Message-ID: <4A1D2B3E.1040306@monstr.eu>
Date: Wed, 27 May 2009 13:59:58 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, john.williams@petalogix.com,
       microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH 08/29] microblaze_mmu_v2: Context handling - mmu_context.c/h
References: <1243406874-3917-1-git-send-email-monstr@monstr.eu> <1243406874-3917-8-git-send-email-monstr@monstr.eu> <1243406874-3917-9-git-send-email-monstr@monstr.eu> <200905271208.07349.arnd@arndb.de>
In-Reply-To: <200905271208.07349.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Wednesday 27 May 2009, Michal Simek wrote:
>>  arch/microblaze/include/asm/mmu_context.h    |   26 +----
>>  arch/microblaze/include/asm/mmu_context_mm.h |  140 ++++++++++++++++++++++++++
>>  arch/microblaze/include/asm/mmu_context_no.h |   23 ++++
>>  arch/microblaze/mm/mmu_context.c             |   70 +++++++++++++
> 
> It would be helpful to create the patches with 'git-format-patch -M -B',
> in order to show renames as what they are, instead of a new file
> and a removed file. For the git pull, this of course doesn't matter.

I resend it. I should rename subject :-(

Michal

> 
> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
