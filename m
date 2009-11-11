Return-Path: <linux-kernel-owner+w=401wt.eu-S1757216AbZKKKru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbZKKKru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 05:47:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754923AbZKKKrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 05:47:49 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59828 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbZKKKrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 05:47:49 -0500
Date: Wed, 11 Nov 2009 11:47:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>, San Mehat <san@google.com>,
       Daniel Walker <dwalker@fifo99.com>, Iliyan Malchev <malchev@google.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Status of Dream series
Message-ID: <20091111104748.GA26975@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Russell, what is the status of the "Dream" series? 

 [PATCH 1/3] msm: make debugging UART (for DEBUG_LL) configurable
 [PATCH 2/3] msm: add minimal board file for HTC Dream device
 [PATCH 3/3] msm: Add memory map for HTC Dream

Daniel Walker offered to maintain arch-msm tree, would that help? 

San would like to port google kernel to newer mainline, so it would be
nice to invent something that works.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
