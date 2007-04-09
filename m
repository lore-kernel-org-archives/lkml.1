Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbXDIVlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbXDIVlg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932274AbXDIVlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:41:31 -0400
Received: from smtp.osdl.org ([65.172.181.24]:33260 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932267AbXDIVlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:41:14 -0400
Date: Mon, 9 Apr 2007 14:41:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, ak@suse.de
Subject: Re: [QUICKLIST 1/4] Quicklists for page table pages V5
Message-Id: <20070409144107.21287fb8.akpm@linux-foundation.org>
In-Reply-To: <20070409182509.8559.33823.sendpatchset@schroedinger.engr.sgi.com>
References: <20070409182509.8559.33823.sendpatchset@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 Apr 2007 11:25:09 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> Quicklists for page table pages V5

So... we skipped i386 this time?

I'd have gone squeamish if it was included, due to the mystery crash when
we (effectively) set the list size to zero.  Someone(tm) should look into 
that - who knows, it might indicate a problem in generic code.

