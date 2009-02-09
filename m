Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbZBIXcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbZBIXcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 18:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbZBIXcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 18:32:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751266AbZBIXcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 18:32:06 -0500
Date: Mon, 9 Feb 2009 15:31:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: zbr@ioremap.net, linux-kernel@vger.kernel.org, ian@beware.dropbear.id.au
Subject: Re: [1/1] w1: w1 temp calculation overflow fix.
Message-Id: <20090209153125.04210608.akpm@linux-foundation.org>
In-Reply-To: <20090209144803.821aa33e.akpm@linux-foundation.org>
References: <20090209214217.GA14958@ioremap.net>
	<20090209135641.0367a71f.akpm@linux-foundation.org>
	<20090209220830.GA15633@ioremap.net>
	<20090209144803.821aa33e.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009 14:48:03 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> But we still don't have a _reason_.  Presumably the bug causes the
> driver to malfunction in some manner.

ah-hah.  I discovered http://bugzilla.kernel.org/show_bug.cgi?id=12646

Now all is revealed!
