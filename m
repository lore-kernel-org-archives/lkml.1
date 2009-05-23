Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbZEWAwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbZEWAwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 20:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758270AbZEWAwR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 20:52:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47292 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758187AbZEWAwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 20:52:17 -0400
Message-ID: <4A1748A9.1020306@zytor.com>
Date: Fri, 22 May 2009 17:51:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: lkml@morethan.org
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG FIX] Make x86_32 uni-processor Atomic ops, Atomic
References: <200905221139.26941.lkml@morethan.org> <200905221721.08495.lkml@morethan.org> <4A173580.9050304@zytor.com> <200905221946.01808.lkml@morethan.org>
In-Reply-To: <200905221946.01808.lkml@morethan.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Zick wrote:
> Same integrated motherboard.

Which means same CPU, same BIOS, same motherboard (none of which you're
telling us.)

cpuinfo and dmidecode would be informative.

	-hpa

