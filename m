Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134AbZCKTbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbZCKTbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 15:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbZCKTay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 15:30:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753854AbZCKTax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 15:30:53 -0400
Date: Wed, 11 Mar 2009 12:27:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: sonic zhang <sonic.adi@gmail.com>
Cc: alan@lxorguk.ukuu.org.uk, cooloney@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] Blackfin Serial Driver: Fix bug - Enable hardware
 based CTS and RTS for bf548. - v2
Message-Id: <20090311122755.094696f8.akpm@linux-foundation.org>
In-Reply-To: <1236679427.28294.16.camel@eight.analog.com>
References: <1236679427.28294.16.camel@eight.analog.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Mar 2009 18:03:47 +0800
sonic zhang <sonic.adi@gmail.com> wrote:

> Both software emulated and hardware based CTS and RTS are enabled in
> serial driver.

In fact all four of these -v2 patches (03, 04, 05 and 17) were identical
to the patches which I merged earlier this week.
