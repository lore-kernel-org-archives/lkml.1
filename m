Return-Path: <linux-kernel-owner+w=401wt.eu-S1759458AbXISXCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458AbXISXCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 19:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbXISXCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 19:02:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50520 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585AbXISXCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 19:02:35 -0400
Date: Wed, 19 Sep 2007 16:02:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Carlos Corbacho <cathectic@gmail.com>
Cc: linux-kernel@vger.kernel.org, Bernhard Rosenkraenzer <bero@arklinux.org>
Subject: Re: [PATCH] Make wistron-btns recognize special keys on Medion
 WIM2160 notebooks
Message-Id: <20070919160230.d3b05b7c.akpm@linux-foundation.org>
In-Reply-To: <fcdsp2$q18$1@sea.gmane.org>
References: <200709141337.36398.bero@arklinux.org>
	<fcdsp2$q18$1@sea.gmane.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please always do reply-to-all.  Otherwise people won't read your email.

On Fri, 14 Sep 2007 12:56:58 +0100
Carlos Corbacho <cathectic@gmail.com> wrote:

> Bernhard Rosenkraenzer wrote:
> 
> > The patch below adds support for Medion WIM2160 notebooks to the
> > wistron-btns driver.
> 
> Do these keys emit proper scancodes though? If yes (i.e. you press a button
> and get a warning about "unknown scancodes" in dmesg), then they should not
> be added to wistron-btns, but to hal-info in userspace.
> 

Bernhard didn't read your email.
