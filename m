Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYBHXEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYBHXEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbYBHXEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:04:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52401 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbYBHXEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:04:36 -0500
Message-ID: <47ACDFE3.9020902@zytor.com>
Date: Fri, 08 Feb 2008 15:04:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Michael Opdenacker <michael-lists@free-electrons.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org, Linux-tiny@selenic.com
Subject: Re: [PATCH] x86 (Linux Tiny): configure out support for some processors
References: <200802082347.25364.michael-lists@free-electrons.com>
In-Reply-To: <200802082347.25364.michael-lists@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Opdenacker wrote:
> This patch against x86/mm tries to revive an original patch
> from Matt Mackall which didn't get merged at that time. It makes
> it possible to disable support code for some processors. This can
> be useful to support only the exact processor type used
> in a given system.

How much is it actually worth?

	-hpa
