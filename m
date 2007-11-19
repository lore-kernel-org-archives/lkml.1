Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbXKSWV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbXKSWV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbXKSWVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:21:18 -0500
Received: from mail.fieldses.org ([66.93.2.214]:49137 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbXKSWVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:21:17 -0500
Date: Mon, 19 Nov 2007 17:21:10 -0500
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.24-rc3-git1: Reported regressions from 2.6.23
Message-ID: <20071119222110.GD22293@fieldses.org>
References: <200711192315.05767.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711192315.05767.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 11:15:05PM +0100, Rafael J. Wysocki wrote:
> Subject		: nfsd gets stuck when underlying filesystem is XFS
> Submitter	: Christian Kujau <lists@nerdbynature.de>
> 		  Chris Wedgwood <cw@f00f.org>
> References	: http://bugzilla.kernel.org/show_bug.cgi?id=9400
> Handled-By	: "J. Bruce Fields" <bfields@fieldses.org>
> Patch		: 

I'm assuming Christoph is handling this:

	http://marc.info/?l=linux-kernel&m=119505424926069&w=2

--b.
