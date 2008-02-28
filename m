Return-Path: <linux-kernel-owner+w=401wt.eu-S932283AbYB1AZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbYB1AZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757471AbYB1AZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:25:34 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756858AbYB1AZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:25:33 -0500
Date: Wed, 27 Feb 2008 16:24:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andres Salomon <dilinger@queued.net>
Cc: adaplas@gmail.com, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, info-linux@geode.amd.com,
       jordan.crouse@amd.com
Subject: Re: [PATCH 3/4] gxfb: Don't enable the CRT DACs when we are in
 flatpanel mode
Message-Id: <20080227162450.a30f6b07.akpm@linux-foundation.org>
In-Reply-To: <20080223011054.0c7529e7@ephemeral>
References: <20080223011054.0c7529e7@ephemeral>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008 01:10:54 -0500
Andres Salomon <dilinger@queued.net> wrote:

> This one's also from Jordan.
> 
> >From dea8d19f689706985b30be745ef1151082866374 Mon Sep 17 00:00:00 2001
> From: Jordan Crouse <jordan.crouse@amd.com>
> Date: Fri, 22 Feb 2008 19:55:09 -0500
> Subject: [PATCH] gxfb: Don't enable the CRT DACs when we are in flatpanel mode

Please do this just by putting Jordan's From: line right at the start of the
changelog.

> When the FP strap is enabled, don't turn on the CRT DACs - that will save
> about 35 mA of power.
> 
> Updated/cleaned up by Andres Salomon.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>
> Acked-by: Jordan Crouse <jordan.crouse@amd.com>

This should have been Signed-off-by: Jordan.  I made that change.
