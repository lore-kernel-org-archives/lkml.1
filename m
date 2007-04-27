Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbXD0NAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbXD0NAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 09:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807AbXD0NAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 09:00:35 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:59811 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755798AbXD0NAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 09:00:17 -0400
Date: Fri, 27 Apr 2007 15:00:01 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] AVR32: Remove useless config option
 "GENERIC_BUST_SPINLOCK".
Message-ID: <20070427150001.23ee5bf7@dhcp-252-105.norway.atmel.com>
In-Reply-To: <Pine.LNX.4.64.0704260851420.2138@localhost.localdomain>
References: <Pine.LNX.4.64.0704260851420.2138@localhost.localdomain>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 08:53:38 -0400 (EDT)
"Robert P. J. Day" <rpjday@mindspring.com> wrote:

> 
> Remove the clearly useless config option GENERIC_BUST_SPINLOCK, which
> is not used anywhere in the tree.
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

Applied. I'll include it in the update I'm planning to send later
today. Thanks.

Haavard
