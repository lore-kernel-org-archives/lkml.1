Return-Path: <linux-kernel-owner+w=401wt.eu-S1763796AbYBWIOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763796AbYBWIOO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932951AbYBWIIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:08:45 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47024 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765531AbYBWIIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:08:43 -0500
Date: Sat, 23 Feb 2008 00:07:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: linux-kernel@vger.kernel.org, linuxconsole-dev@lists.sourceforge.net
Subject: Re: [PATCH] VT notifier extension for accessibility
Message-Id: <20080223000713.2707833e.akpm@linux-foundation.org>
In-Reply-To: <20080215172516.GK4511@implementation>
References: <20080215172516.GK4511@implementation>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2008 18:25:16 +0100 Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:

> Some accessibility modules need to be able to catch the output on the
> console before the VT interpretation, and possibly swallow it.
> 
> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> From: Karl Dahlke <eklhad@comcast.net>

Please put the From: at the very top of the changelog when providing
attribution.

Did we have a signed-off-by: from Karl?

> --- include/linux/notifier.h	2008-02-15 08:44:10.000000000 -0500
> +++ include/linux/notifier.h.new	2008-02-15 09:58:00.000000000 -0500

Please prepare patches in `patch -p1' form, thanks.

