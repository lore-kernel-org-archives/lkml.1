Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbYHFM4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbYHFM4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 08:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbYHFMzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 08:55:39 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59109 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbYHFMzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 08:55:32 -0400
Date: Wed, 6 Aug 2008 11:02:47 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>
Subject: 2.6.27-rc1: critical thermal shutdown on thinkpad x60
Message-ID: <20080806090246.GA1572@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Aug  6 11:00:10 amd kernel: ACPI: Critical trip point
Aug  6 11:00:10 amd kernel: Critical temperature reached (128 C),
shutting down.
Aug  6 11:00:10 amd shutdown[24414]: shutting down for system halt

...and machine went down at that point :-(.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
