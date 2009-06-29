Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbZF2TmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbZF2TmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 15:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZF2Tlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 15:41:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752520AbZF2Tlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 15:41:55 -0400
Date: Mon, 29 Jun 2009 12:41:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, swetland@google.com
Subject: Re: Framebuffer support for HTC Dream
Message-Id: <20090629124132.e84e3d21.akpm@linux-foundation.org>
In-Reply-To: <20090629111029.GA15514@elf.ucw.cz>
References: <20090629111029.GA15514@elf.ucw.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009 13:10:30 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> I cleaned up dead code, a lot of debugging infastructure and horrific
> logo code. I had to remove earlysuspend support, because neccessary
> headers are not in mainline. The driver still works :-).

The patch still generates a world-record amount of checkpatch output,
quite a lot of which could be safely ignored, but some of which we
should fix?
