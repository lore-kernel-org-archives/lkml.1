Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbYKZBVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbYKZBVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 20:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbYKZBVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 20:21:34 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752926AbYKZBVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 20:21:33 -0500
Date: Tue, 25 Nov 2008 17:20:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: dwmw2@infradead.org, jens.axboe@oracle.com, matthew@wil.cx,
       joern@logfs.org, James.Bottomley@HansenPartnership.com,
       djshin90@gmail.com, teheo@suse.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] swapfile: swapon randomize if nonrot
Message-Id: <20081125172039.c9a35460.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0811252146090.20455@blonde.site>
References: <Pine.LNX.4.64.0811252132580.17555@blonde.site>
	<Pine.LNX.4.64.0811252140230.17555@blonde.site>
	<Pine.LNX.4.64.0811252146090.20455@blonde.site>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008 21:46:56 +0000 (GMT)
Hugh Dickins <hugh@veritas.com> wrote:

> But how to get my SD card, accessed by USB card reader, reported as NONROT?

Dunno.  udev rules, perhaps?
