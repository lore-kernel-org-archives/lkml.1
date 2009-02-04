Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbZBDCKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbZBDCKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 21:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZBDCKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 21:10:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37536 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbZBDCKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 21:10:31 -0500
Message-ID: <4988F8F5.9070706@zytor.com>
Date: Tue, 03 Feb 2009 18:09:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       linux-kernel@vger.kernel.org
Subject: Re: APIC: enable workaround on AMD Fam10h CPUs
References: <20090203172200.GA3955@aftab>
In-Reply-To: <20090203172200.GA3955@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> Date: Tue, 3 Feb 2009 16:24:22 +0100
> Subject: [PATCH] APIC: enable workaround on AMD Fam10h CPUs

Applied to tip:x86/urgent.

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

