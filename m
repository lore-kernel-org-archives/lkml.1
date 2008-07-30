Return-Path: <linux-kernel-owner+w=401wt.eu-S1759915AbYG3LJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915AbYG3LJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 07:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYG3LJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 07:09:27 -0400
Received: from twin.jikos.cz ([213.151.79.26]:56615 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbYG3LJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:09:27 -0400
Date: Wed, 30 Jul 2008 13:09:13 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Jonathan Corbet <corbet@lwn.net>
cc: LKML <linux-kernel@vger.kernel.org>,
       Amanda McPherson <amanda@amcpherson.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC] A development process document
In-Reply-To: <20080729143015.0f79cf37@bike.lwn.net>
Message-ID: <Pine.LNX.4.64.0807301307060.26427@twin.jikos.cz>
References: <20080729143015.0f79cf37@bike.lwn.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008, Jonathan Corbet wrote:

> +Over the next six to ten weeks, only patches which fix problems should be
> +submitted to the mainline.  On occasion a more significant change will be
> +allowed, but such occasions are rare; developers who try to merge new
> +features outside of the merge window tend to get an unfriendly reception.
> +As a general rule, if you miss the merge window for a given feature, the
> +best thing to do is to wait for the next development cycle.

On the other hand, the drivers for completely new hardware (that has been 
totally unsupported by the kernel previously, so there is no possibility 
for introducing regressions) are still allowed even after -rc1, right? 

This might be worth explicit note here.

Thanks,

-- 
Jiri Kosina
SUSE Labs

