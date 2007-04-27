Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbXD0Vfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbXD0Vfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757347AbXD0Vfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:35:52 -0400
Received: from colin.muc.de ([193.149.48.1]:3192 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757350AbXD0Vft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:35:49 -0400
Date: 27 Apr 2007 23:35:46 +0200
Date: Fri, 27 Apr 2007 23:35:46 +0200
From: Andi Kleen <ak@muc.de>
To: Tim Hockin <thockin@google.com>
Cc: Vojtech Pavlik <vojtech@suse.cz>, linux-kernel@vger.kernel.org,
       akpm@google.com
Subject: Re: [PATCH] x86_64: dynamic MCE poll interval (try 2)
Message-ID: <20070427213546.GA58885@muc.de>
References: <cc96a5040704271434j441967fcr5530c6f15f7026e8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc96a5040704271434j441967fcr5530c6f15f7026e8@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 02:34:11PM -0700, Tim Hockin wrote:
> From: Tim Hockin <thockin@google.com>
> 
> Background:
> We've found that MCEs (specifically DRAM SBEs) tend to come in bunches,
> especially when we are trying really hard to stress the system out.  The
> current MCE poller uses a static interval which does not care whether it
> has or has not found MCEs recently.

Added thanks

-Andi
