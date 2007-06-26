Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbXFZUc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbXFZUc3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 16:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757602AbXFZUcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 16:32:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43657 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756665AbXFZUcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 16:32:20 -0400
Date: Tue, 26 Jun 2007 13:32:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] remove nobh_{prepare,commit}_write()
Message-Id: <20070626133203.d1aa5383.akpm@linux-foundation.org>
In-Reply-To: <20070614221555.GY3588@stusta.de>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
	<20070614221555.GY3588@stusta.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007 00:15:55 +0200
Adrian Bunk <bunk@stusta.de> wrote:

> nobh_{prepare,commit}_write() are no longer used.

wth?  What happened to ext2 and ext3 nobh mode?  They seem to
have magically and unchangeloggedly disappeared?
