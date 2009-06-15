Return-Path: <linux-kernel-owner+w=401wt.eu-S1759542AbZFOIk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542AbZFOIk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757805AbZFOIkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:40:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47832 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758626AbZFOIkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:40:39 -0400
Date: Mon, 15 Jun 2009 10:40:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Patches to get serial working on msm7k / htc dream
Message-ID: <20090615084034.GB10822@elf.ucw.cz>
References: <1245033557-10968-1-git-send-email-swetland@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245033557-10968-1-git-send-email-swetland@google.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-06-14 19:39:14, Brian Swetland wrote:
> This short patch series brings in the driver for the SoC's UART, 
> some configuration glue to select a debug UART, updates for the 
> debug uart macros, and a very minimal board file for HTC Dream.

Wow, thanks!
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
