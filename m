Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbXFBGym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbXFBGym (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 02:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbXFBGyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 02:54:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52568 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754520AbXFBGye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 02:54:34 -0400
Date: Fri, 1 Jun 2007 23:54:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Jan Kara <jack@suse.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Fix possible leakage of blocks in UDF
Message-Id: <20070601235422.fdc1f750.akpm@linux-foundation.org>
In-Reply-To: <20070602063403.GA8387@cvg>
References: <20070524165935.GB19709@duck.suse.cz>
	<20070524170554.GC19709@duck.suse.cz>
	<20070524203653.GA7693@duck.suse.cz>
	<465DF0B4.2050203@sandeen.net>
	<20070601211036.GA23975@duck.suse.cz>
	<46609FBD.5040407@sandeen.net>
	<20070601154834.53558d1b.akpm@linux-foundation.org>
	<4660FD7F.4090302@sandeen.net>
	<20070601224339.c803e04e.akpm@linux-foundation.org>
	<20070602063403.GA8387@cvg>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jun 2007 10:34:03 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> | That patch is DOA, methinks.
> | 
> 
> Andrew, what does it mean - "DOA"? Dead on arrival?

yes - I dropped it.
