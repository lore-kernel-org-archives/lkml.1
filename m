Return-Path: <linux-kernel-owner+w=401wt.eu-S965248AbXFFGsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965248AbXFFGsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 02:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964980AbXFFGsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 02:48:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43522 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965197AbXFFGsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 02:48:22 -0400
Date: Tue, 5 Jun 2007 23:48:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Lloyd <klloyd@sierrawireless.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net, torvalds@linux-foundation.org
Subject: Re: [PATCH 2.6.21.3] USB: add support for TRU-install and new
 VID/PIDs to Sierra Wireless driver
Message-Id: <20070605234805.b03bb87c.akpm@linux-foundation.org>
In-Reply-To: <4665D518.8020508@sierrawireless.com>
References: <4665D518.8020508@sierrawireless.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Jun 2007 14:26:48 -0700 Kevin Lloyd <klloyd@sierrawireless.com> wrote:

> This patch is derived from the 2.6.21.3 kernel source and adds support for the new TRU-install
> feature (without this support new devices will not work), and add new UMTS device VID/PIDs.

2.6.21.3 is quite old, sorry.  The patch throws several rejects.

Against 2.6.22-rc4 would be preferred.  Against git-snapshot-of-the-day
from ftp://ftp.kernel.org/pub/linux/kernel/v2.6/snapshots/ is even better.
