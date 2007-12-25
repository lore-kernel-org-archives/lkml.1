Return-Path: <linux-kernel-owner+w=401wt.eu-S1752629AbXLYWGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbXLYWGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 17:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbXLYWF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 17:05:56 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38937 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752182AbXLYWFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 17:05:54 -0500
Date: Tue, 25 Dec 2007 14:05:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/63] ide-cd: redux
Message-Id: <20071225140514.fa13f5ac.akpm@linux-foundation.org>
In-Reply-To: <200712200148.49690.bzolnier@gmail.com>
References: <200712200148.49690.bzolnier@gmail.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 01:48:49 +0100 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> This patch series is a major rework of the ide-cd driver.

woo-hoo.

> PS ide-cd Maintainer position is still open...

boo-hoo.

I wish someone would fix that "The drive appears confused (ireason =
0x%02x)" thing.  I had a go a while back but iirc the reporter disappeared
on me.  It is somewhat common.

Or do you think this patch might indeed fix it?
