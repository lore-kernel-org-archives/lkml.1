Return-Path: <linux-kernel-owner+w=401wt.eu-S1763973AbYHEU34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763973AbYHEU34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762344AbYHEU3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:29:45 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:40257 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761975AbYHEU3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:29:44 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Subject: Re: 2.6.27-rc1-mm1: unable to boot with gcov on x86_64
Date: Tue, 5 Aug 2008 22:29:42 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
References: <20080731000354.24b55d5b.akpm@linux-foundation.org> <200808052226.36626.m.kozlowski@tuxland.pl>
In-Reply-To: <200808052226.36626.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808052229.42737.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello Peter,
> 
> 	I'm seeing similar GCOV problems as with 2.6.26-rc5-mm1 that you fixed.
> This is the same x86_64 box and again it was unable to boot with gcov enabled.
> A quick look revealed that arch/x86/tsc_64.c and arch/x86/tsc_32.c code was

Make that arch/x86/kernel/tsc_64.c and arch/x86/kernel/tsc_32.c

	Mariusz
