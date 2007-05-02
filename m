Return-Path: <linux-kernel-owner+w=401wt.eu-S2993094AbXEBMVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993094AbXEBMVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 08:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993093AbXEBMVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 08:21:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:52869 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993084AbXEBMVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 08:21:52 -0400
Date: Wed, 2 May 2007 14:21:47 +0200
From: Olaf Hering <olh@suse.de>
To: Kristian =?utf-8?B?SMO4Z3NiZXJn?= <krh@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux1394-devel <linux1394-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] New firewire stack
Message-ID: <20070502122147.GA31215@suse.de>
References: <4637A29F.6070302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4637A29F.6070302@redhat.com>
X-DOS: I got your 640K Real Mode Right Here Buddy!
X-Homeland-Security: You are not supposed to read this line! You are a terrorist!
User-Agent: Mutt und vi sind doch schneller als Notes (und GroupWise)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, Kristian Høgsberg wrote:

>   drivers/firewire/Kconfig          |   60 ++

NACK.
Upgrade the current drivers/ieee1394/ with the new code, and keep all
existing module names.
