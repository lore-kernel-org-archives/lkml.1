Return-Path: <linux-kernel-owner+w=401wt.eu-S1762073AbXLREeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762073AbXLREeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 23:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbXLREdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 23:33:53 -0500
Received: from ozlabs.org ([203.10.76.45]:48238 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbXLREdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 23:33:52 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Adam Jackson <ajax@redhat.com>
Subject: Re: [PATCH] apm_event{,info}_t are userspace types.
Date: Tue, 18 Dec 2007 15:33:46 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
References: <1196452963295-git-send-email-ajax@redhat.com>
In-Reply-To: <1196452963295-git-send-email-ajax@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712181533.46596.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 December 2007 07:02:43 Adam Jackson wrote:
> These types define the size of data read from /dev/apm_bios.  They
> should not be hidden behind #ifdef __KERNEL__.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

My mistake, sorry.

Rusty.
