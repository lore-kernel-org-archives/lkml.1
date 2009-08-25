Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbZHYIqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbZHYIqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbZHYIqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:46:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40351 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbZHYIqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:46:06 -0400
Date: Tue, 25 Aug 2009 10:46:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH V4 2/2] introduce ACPI ALS device driver
Message-ID: <20090825084601.GM29763@elf.ucw.cz>
References: <1251184696.3483.96.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251184696.3483.96.camel@rzhang-dt>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-08-25 15:18:16, Zhang Rui wrote:
> ???ACPI spec defines ACPI Ambient Light Sensor device (hid ACPI0008),
> which provides a standard interface by which the OS may query properties
> of the ambient light environment the system is currently operating in,
> as well as the ability to detect meaningful changes in these values when
> the environment changes.
> 
> This patch introduces the ACPI ALS device driver.
> 
> Signed-off-by: Zhang Rui <rui.zhang@intel.com>

ACK... and thanks for patience.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
