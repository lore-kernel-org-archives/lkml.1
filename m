Return-Path: <linux-kernel-owner+w=401wt.eu-S1752052AbXCEXXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbXCEXXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 18:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbXCEXXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 18:23:36 -0500
Received: from [198.99.130.12] ([198.99.130.12]:49802 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbXCEXXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 18:23:36 -0500
Date: Mon, 5 Mar 2007 18:14:54 -0500
From: Jeff Dike <jdike@addtoit.com>
To: mrkiko <mrkiko.rs@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: problems compiling UML
Message-ID: <20070305231454.GC9525@ccure.user-mode-linux.org>
References: <elmo11730948321025164440876@mmx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <elmo11730948321025164440876@mmx>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 12:40:32PM +0100, mrkiko wrote:
> Problem:
> make all ARCH=um fails always on linking: it seems that a -llibname is 
> missing.  If this report is too stupid, sorry!

It's not too stupid - it's too short on details.

Show us the relevant portion of the build output.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
