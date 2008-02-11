Return-Path: <linux-kernel-owner+w=401wt.eu-S1760106AbYBKXCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760106AbYBKXCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 18:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYBKXCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 18:02:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51674 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbYBKXCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 18:02:37 -0500
Message-ID: <47B0D3B7.6070308@zytor.com>
Date: Mon, 11 Feb 2008 15:01:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Michael Opdenacker <michael-lists@free-electrons.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Linux-tiny@selenic.com
Subject: Re: [PATCH] x86 (Linux Tiny): configure out support for some	processors
References: <200802082347.25364.michael-lists@free-electrons.com>	 <20080208231130.GA10511@elte.hu>	 <200802112342.23493.michael-lists@free-electrons.com> <1202770566.12383.59.camel@cinder.waste.org>
In-Reply-To: <1202770566.12383.59.camel@cinder.waste.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> 
> Best would be to have no ifdefs and do it all with linker magic, of
> course. But that's trickier.
> 

I concur with this, definitely.

	-hpa
