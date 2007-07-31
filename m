Return-Path: <linux-kernel-owner+w=401wt.eu-S940362AbXGaBZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940362AbXGaBZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 21:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbXGaBZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 21:25:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46991 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751888AbXGaBZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 21:25:45 -0400
Date: Mon, 30 Jul 2007 18:25:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: ian <spyro@f2s.com>, john@dnsworld.co.uk, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk
Subject: Re: [2.6 patch] Remove the arm26 port
Message-Id: <20070730182502.633bf112.akpm@linux-foundation.org>
In-Reply-To: <20070730114914.GN16817@stusta.de>
References: <20070707201208.GJ3492@stusta.de>
	<20070729115040.GD30976@stusta.de>
	<1185749926.2305.16.camel@wirenth>
	<20070730114914.GN16817@stusta.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jul 2007 13:49:14 +0200 Adrian Bunk <bunk@stusta.de> wrote:

> The arm26 port has been in a state where it was far from even compiling 
> for quite some time.
> 
> Ian Molton agreed with the removal.

OK, thanks, I queued that up for a 2.6.23 merge.
