Return-Path: <linux-kernel-owner+w=401wt.eu-S932620AbYETUEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620AbYETUEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 16:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759024AbYETUEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 16:04:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758613AbYETUEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 16:04:15 -0400
Date: Tue, 20 May 2008 13:03:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: anemo@mba.ocn.ne.jp, a.zummo@towertech.it, hvr@gnu.org,
       rtc-linux@googlegroups.com, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RTC: M41T80: Century Bit support
Message-Id: <20080520130311.58a8e5ac.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.55.0805202045320.31790@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0805170057370.4049@cliff.in.clinika.pl>
	<20080518.000242.41199304.anemo@mba.ocn.ne.jp>
	<Pine.LNX.4.55.0805171959030.10067@cliff.in.clinika.pl>
	<20080519.011034.25909336.anemo@mba.ocn.ne.jp>
	<Pine.LNX.4.55.0805202045320.31790@cliff.in.clinika.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 20:51:56 +0100 (BST)
"Maciej W. Rozycki" <macro@linux-mips.org> wrote:

>  Andrew, could you please hold the patch in -mm till the flags have been 
> added?

It's be saner for me to drop it and have you resend when appropriate. 
The chances of me being able to succesfully correlate this patch and
something called "the flags" at some time in the future are less than
100% ;)

