Return-Path: <linux-kernel-owner+w=401wt.eu-S1765123AbYEATn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765123AbYEATn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761602AbYEATnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:43:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33986 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761231AbYEATnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:43:19 -0400
Message-ID: <481A1D3A.5040202@zytor.com>
Date: Thu, 01 May 2008 12:42:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: yhlu.kernel@gmail.com
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gabriel C <nix.or.die@googlemail.com>,
       Mika Fischer <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete
 - auto detect v2
References: <200804272337.40130.yhlu.kernel@gmail.com> <200804292025.58268.yhlu.kernel@gmail.com> <200805010100.34751.yhlu.kernel@gmail.com> <200805011157.00693.yhlu.kernel@gmail.com>
In-Reply-To: <200805011157.00693.yhlu.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> loop mtrr chunk_size and gran_size from 1M to 2G to find out optimal value.

Why stopping at 2 GB?

