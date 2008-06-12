Return-Path: <linux-kernel-owner+w=401wt.eu-S1761321AbYFLNK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761321AbYFLNK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759945AbYFLNKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:10:12 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4179 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759026AbYFLNKK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:10:10 -0400
Date: Thu, 12 Jun 2008 15:09:40 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Samuel Ortiz <samuel@sortiz.org>
Subject: Re: [PATCH 2/4] Remove references to struct pm_dev from IRDA headers
Message-ID: <20080612130939.GB5455@ucw.cz>
References: <200806121025.24668.rjw@sisk.pl> <200806121029.30961.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806121029.30961.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-06-12 10:29:30, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Some IRDA headers contain references to 'struct pm_dev' that are not
> necessary any more and may be removed.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.
						Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
