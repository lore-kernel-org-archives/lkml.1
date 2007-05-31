Return-Path: <linux-kernel-owner+w=401wt.eu-S1760775AbXEaEwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760775AbXEaEwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 00:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760641AbXEaEvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 00:51:54 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:46888 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760632AbXEaEvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 00:51:53 -0400
Date: Thu, 31 May 2007 06:52:54 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: section mismatches
Message-ID: <20070531045254.GC20795@uranus.ravnborg.org>
References: <20070530180217.bebfa4b0.akpm@linux-foundation.org> <86802c440705302140i36abac48va40618b79fb52521@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440705302140i36abac48va40618b79fb52521@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 09:40:27PM -0700, Yinghai Lu wrote:
> please check patch in following too.
> 
> http://lkml.org/lkml/2007/5/25/76

Patch looks wrong (why remove all the markings).
In output posted by Andrew there is no references to mtrr - so I expect it
to be all clear in Andi's tree.

	Sam
