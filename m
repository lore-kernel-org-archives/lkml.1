Return-Path: <linux-kernel-owner+w=401wt.eu-S1759446AbZFRK0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446AbZFRK0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 06:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756997AbZFRK01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 06:26:27 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46844 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536AbZFRK00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 06:26:26 -0400
Date: Thu, 18 Jun 2009 12:26:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] [ARM] msm: make debugging UART (for DEBUG_LL)
	configurable
Message-ID: <20090618102622.GD28892@elf.ucw.cz>
References: <1245285075-20022-1-git-send-email-swetland@google.com> <1245285075-20022-2-git-send-email-swetland@google.com> <1245285075-20022-3-git-send-email-swetland@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245285075-20022-3-git-send-email-swetland@google.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-06-17 17:31:14, Brian Swetland wrote:
> Provides options to select one of the three "lowspeed" UARTs
> on MSM7k SoCs for DEBUG_LL output from the zImage decompressor
> and kernel.
> 
> Signed-off-by: Brian Swetland <swetland@google.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
