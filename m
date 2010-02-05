Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688Ab0BEVrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 16:47:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757518Ab0BEVrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 16:47:03 -0500
Date: Fri, 5 Feb 2010 13:46:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Chris Verges" <chrisv@cyberswitching.com>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, "Rob Owings" <rowings@thermistor.com>
Subject: Re: [PATCH] linux-2.6.32-directemp
Message-Id: <20100205134600.59eb8fae.akpm@linux-foundation.org>
In-Reply-To: <68FBE0F3CE97264395875AC1C468F22C24A608@mail03.cyberswitching.local>
References: <68FBE0F3CE97264395875AC1C468F22C24A5BD@mail03.cyberswitching.local>
	<20100205124038.4f1e83ac.akpm@linux-foundation.org>
	<68FBE0F3CE97264395875AC1C468F22C24A608@mail03.cyberswitching.local>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Feb 2010 13:32:27 -0800
"Chris Verges" <chrisv@cyberswitching.com> wrote:

> > *snip*
> 
> Hi Andrew,
> 
> Thanks for the technical review.  I'll make the changes and send back a
> new patch.  Would you like a patch against your -mm tree or a fresh
> patch against linux-2.6.32?

I guess a new patch would be best - #1 was a bit of a mess.  Please
give the patch a good title (I chose "usb: QTI DirecTEMP USB
thermometer/hygrometer driver support") and if possible, include it
within the body of the email so more people are likely to look at it. 
If your email client can't do that correctly, use a text/plain
attachment.

Thanks.
