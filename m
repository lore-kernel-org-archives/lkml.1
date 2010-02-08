Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab0BHXrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 18:47:48 -0500
Received: from mail.vyatta.com ([76.74.103.46]:50146 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab0BHXrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 18:47:47 -0500
Date: Mon, 8 Feb 2010 15:47:35 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml@Think-Future.de, Linux Kernel-Liste <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: PROBLEM: oops w/ bridge in 2.6.32.7
Message-ID: <20100208154735.1d60f43c@nehalam>
In-Reply-To: <20100208142044.6be97024.akpm@linux-foundation.org>
References: <20100206165351.GA9411@localhost>
	<20100208142044.6be97024.akpm@linux-foundation.org>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Feb 2010 14:20:44 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> > virtualbox-ose              3.1.2-dfsg-1+b1
> > virtualbox-ose-source       3.1.2-dfsg-1
> > 


Sorry, since virtualbox is not part of standard mainline kernel,
I suspect the problem is there.
Please reproduce with standard 2.6.32.X distribution.
