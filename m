Return-Path: <linux-kernel-owner+w=401wt.eu-S1754481Ab0AHXv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab0AHXv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 18:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441Ab0AHXvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 18:51:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754432Ab0AHXvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 18:51:23 -0500
Date: Fri, 8 Jan 2010 15:51:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-arch@vger.kernel.org,
       ebiederm@xmission.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [2/9] Add a kernel_address() that works for data too
Message-Id: <20100108155111.980b7fd4.akpm@linux-foundation.org>
In-Reply-To: <20100105191503.GH1778@basil.fritz.box>
References: <20100105315.789846878@firstfloor.org>
	<20100105021527.1AB19B17C2@basil.firstfloor.org>
	<20100105085853.GA28126@merkur.ravnborg.org>
	<20100105190455.GE30868@flint.arm.linux.org.uk>
	<20100105191503.GH1778@basil.fritz.box>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010 20:15:03 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> > I'd suggest the only way to identify the data segment in a generic way
> > is to have everyone define _sdata, or more preferably _data (to be
> > consistent with _text), to be the start of the data segment.
> 
> I agree. I'll take a look at that.
> 

I'll merge this as-is for now.  Please send updates when convenient.
