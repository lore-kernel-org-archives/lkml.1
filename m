Return-Path: <linux-kernel-owner+w=401wt.eu-S1751306AbXC0KEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbXC0KEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 06:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbXC0KEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 06:04:12 -0400
Received: from holomorphy.com ([66.93.40.71]:57013 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbXC0KEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 06:04:11 -0400
Date: Tue, 27 Mar 2007 03:04:11 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm2
Message-ID: <20070327100411.GB2986@holomorphy.com>
References: <20070326211627.c681af3b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326211627.c681af3b.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 09:16:27PM -0800, Andrew Morton wrote:
> - This is the same as 2.6.12-rc5-mm1, except the staircase deadline CPU
>   scheduler has been added.

This boots without incident on the Altix I've got where prior versions
of RSDL all had issues. Count RSDL as fixed here.


-- wli
