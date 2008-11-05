Return-Path: <linux-kernel-owner+w=401wt.eu-S1757015AbYKEUqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015AbYKEUqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 15:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbYKEUql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 15:46:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755778AbYKEUqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 15:46:40 -0500
Date: Wed, 5 Nov 2008 12:45:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Andrew Victor" <avictor.za@gmail.com>
Cc: wim@iguana.be, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SAM9 watchdog - supported on all SAM9 and CAP9
 processors
Message-Id: <20081105124543.7679a313.akpm@linux-foundation.org>
In-Reply-To: <cd73a99e0811051236x3c852ce7w5d16a695d8efb9c6@mail.gmail.com>
References: <cd73a99e0811051236x3c852ce7w5d16a695d8efb9c6@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2008 22:36:35 +0200
"Andrew Victor" <avictor.za@gmail.com> wrote:

> The SAM9 watchdog driver is usable on the whole family of AT91SAM9 and
> CAP9 processors.
> Update the configuration to indicate this and allow the driver to be selected.
> 
> Signed-off-by: Andrew Victor <linux@maxim.org.za>
> 

I queued your sam9-watchdog-update-for-moved-headers.patch for
immediate mainline merge by myself.

I queued this patch
(sam9-watchdog-supported-on-all-sam9-and-cap9-processors.patch) for
sending to Wim with a for-2.6.28 suggestion.

> [sam9_wdt_config.patch  text/x-patch (821B)]

sylpheed mucks that up.  text/plain attachments would be preferred,
please.  Inlined non-wordwrapped, non-tab-replaced, non-space-stuffed
text would of course be even better.
