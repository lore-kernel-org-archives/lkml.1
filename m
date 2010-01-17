Return-Path: <linux-kernel-owner+w=401wt.eu-S1754335Ab0AQSOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab0AQSOV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 13:14:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284Ab0AQSOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 13:14:21 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35098 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752883Ab0AQSOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 13:14:20 -0500
Date: Sun, 17 Jan 2010 18:17:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: alan@linux.intel.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: Two branches the same in timbuart_set_mctrl()
Message-ID: <20100117181702.026269e9@lxorguk.ukuu.org.uk>
In-Reply-To: <4B532CF5.7080000@gmail.com>
References: <4B532CF5.7080000@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jan 2010 16:29:57 +0100
Roel Kluin <roel.kluin@gmail.com> wrote:

> Regardless of the condition, the branches execute the same code
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Was this maybe intended? please review.

I don't have data sheets and I'm very unwilling to play guess the
intended behaviour in the absence of an actual bug report.

I'd suggest you contanct the original author because as you note -
somthing looks odd indeed.

Alan
