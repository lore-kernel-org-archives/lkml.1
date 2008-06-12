Return-Path: <linux-kernel-owner+w=401wt.eu-S1761449AbYFLNKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761449AbYFLNKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761273AbYFLNKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:10:20 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4186 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761253AbYFLNKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:10:18 -0400
Date: Thu, 12 Jun 2008 15:10:05 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 3/4] Remove definition of struct pm_dev
Message-ID: <20080612131005.GC5455@ucw.cz>
References: <200806121025.24668.rjw@sisk.pl> <200806121030.26099.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806121030.26099.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-06-12 10:30:25, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Remove the definition of 'struct pm_dev', which is not used any more,
> along with some related stuff from include/linux/pm.h .
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
