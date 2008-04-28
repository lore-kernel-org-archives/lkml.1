Return-Path: <linux-kernel-owner+w=401wt.eu-S937123AbYD1VDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937123AbYD1VDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934620AbYD1VDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:03:40 -0400
Received: from vigor.karmaclothing.net ([217.169.26.28]:42980 "EHLO
	dl5rb.ham-radio-op.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934532AbYD1VDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:03:40 -0400
X-Greylist: delayed 610 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Apr 2008 17:03:39 EDT
Date: Mon, 28 Apr 2008 21:53:14 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/15] [MIPS] pmc-sierra/msp71xx/msp_hwbutton.c: minor
	irq handler cleanups
Message-ID: <20080428205314.GA12221@linux-mips.org>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com> <1fe60a9e2aaf5ddc410e5eefd7aa1163821c59b5.1208559659.git.jgarzik@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fe60a9e2aaf5ddc410e5eefd7aa1163821c59b5.1208559659.git.jgarzik@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 07:23:01PM -0400, Jeff Garzik wrote:

> - remove always-true test
> 
> - neaten request_irq() indentation
> 
> This change's main purpose is to prepare for the patchset in
> jgarzik/misc-2.6.git#irq-remove, that explores removal of the
> never-used 'irq' argument in each interrupt handler.
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

Applied, thanks Jeff.

  Ralf
