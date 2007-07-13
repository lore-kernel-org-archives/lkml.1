Return-Path: <linux-kernel-owner+w=401wt.eu-S935431AbXGMGvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935431AbXGMGvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 02:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753973AbXGMGva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 02:51:30 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53188 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760060AbXGMGv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 02:51:29 -0400
Date: Thu, 12 Jul 2007 23:51:09 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bryan Wu <bryan.wu@analog.com>, Greg KH <greg@kroah.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       Nish Aravamudan <nish.aravamudan@gmail.com>
Subject: Re: Linux 2.6.22.1
Message-ID: <20070713065109.GD4306@sequoia.sous-sol.org>
References: <29495f1d0707121135u2a07cf04nb8bfe555c5c63679@mail.gmail.com> <1184307380.8943.7.camel@roc-desktop> <20070713061617.GA24317@kroah.com> <1184308100.8943.12.camel@roc-desktop> <alpine.LFD.0.999.0707122328340.20061@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707122328340.20061@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> In that case, it's almost certainly that that tree isn't doing the proper 
> "git update-server-info" when people push to it.

Yup, should be fixed now.

thanks,
-chris
