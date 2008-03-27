Return-Path: <linux-kernel-owner+w=401wt.eu-S1758158AbYC0IMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758158AbYC0IMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 04:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309AbYC0IMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 04:12:24 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:42088
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755402AbYC0IMX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 04:12:23 -0400
Message-Id: <47EB56E0020000780004917E@public.id2-vpn.continvity.gns.novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 27 Mar 2008 08:12:16 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>
Cc: <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [RFC] x86: bitops asm constraint fixes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please revert it for the time being, I've got a better version (i.e.
without extra dead code being generated) that I intended to
submit once I know whether the other issues pointed out in the
description on the original patch also should be adjusted. Of
course, that could also be done incrementally, but I would think
overhauling the whole file at once wouldn't be a bad thing...

Jan

>>> Ingo Molnar <mingo@elte.hu> 03/21/08 2:54 PM >>>

thanks Jan, i've applied your patch.

	Ingo

