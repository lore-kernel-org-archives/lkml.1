Return-Path: <linux-kernel-owner+w=401wt.eu-S1764242AbXKPD0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764242AbXKPD0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 22:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756610AbXKPDZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 22:25:59 -0500
Received: from [198.99.130.12] ([198.99.130.12]:54883 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756128AbXKPDZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 22:25:58 -0500
Date: Thu, 15 Nov 2007 22:25:49 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm creation/destruction hooks
Message-ID: <20071116032549.GB12516@c2.user-mode-linux.org>
References: <20071115234648.GA10948@c2.user-mode-linux.org> <473CE2B6.3090304@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473CE2B6.3090304@goop.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 04:22:14PM -0800, Jeremy Fitzhardinge wrote:
> activate_mm() does that.

Yup, which I realized ~10 seconds after sending mail...

Oh well.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
