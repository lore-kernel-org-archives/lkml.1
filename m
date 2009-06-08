Return-Path: <linux-kernel-owner+w=401wt.eu-S1756990AbZFHPXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbZFHPXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 11:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756653AbZFHPXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 11:23:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35732 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178AbZFHPXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 11:23:20 -0400
Date: Mon, 8 Jun 2009 08:37:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [RFC][PATCH 2/2] PM/Hibernate: Rename disk.c to hibernate.c
Message-ID: <20090608063750.GB1833@ucw.cz>
References: <200906070054.19207.rjw@sisk.pl> <200906070056.55418.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906070056.55418.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-06-07 00:56:54, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Change the name of kernel/power/disk.c to kernel/power/hibernate.c
> in analogy with the file names introduced by the changes that
> separated the suspend to RAM and standby funtionality from the
> common PM functions.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
