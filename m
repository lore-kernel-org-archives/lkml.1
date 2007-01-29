Return-Path: <linux-kernel-owner+w=401wt.eu-S933241AbXA2Gqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241AbXA2Gqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 01:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933242AbXA2Gqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 01:46:39 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51587 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933241AbXA2Gqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 01:46:38 -0500
Date: Sun, 28 Jan 2007 22:46:36 -0800
From: Andrew Morton <akpm@osdl.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add PA Semi PCI vendor id
Message-Id: <20070128224636.e88428fc.akpm@osdl.org>
In-Reply-To: <20070129061424.GB7814@lixom.net>
References: <20070129061424.GB7814@lixom.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007 00:14:24 -0600
Olof Johansson <olof@lixom.net> wrote:

> Add PA Semi's PCI vendor ID (0x1959).
> 
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> 
> ---
> 
> Submitting this separately -- several drivers that have recently been
> posted could make use of it. I didn't want to include it in each of them
> and have patch conflicts when they're combined upstream.

I'd suggest you do it all in a single patch.
