Return-Path: <linux-kernel-owner+w=401wt.eu-S1760905AbXHWJZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760905AbXHWJZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 05:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757781AbXHWJZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 05:25:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:33773 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756115AbXHWJZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 05:25:48 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: Re: [PATCH] Implement missing x86_64 function smp_call_function_mask()
Date: Thu, 23 Aug 2007 11:25:38 +0200
User-Agent: KMail/1.9.6
Cc: discuss@x86-64.org, linux-kernel <linux-kernel@vger.kernel.org>
References: <46CD38E5.4000704@bull.net>
In-Reply-To: <46CD38E5.4000704@bull.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708231125.38816.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 August 2007 09:36:05 Laurent Vivier wrote:
> This patch defines the missing function smp_call_function_mask() for x86_64,
> this is more or less a cut&paste of i386 function.

What do you need it for?

-Andi
