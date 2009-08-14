Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbZHOQVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbZHOQVb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 12:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbZHOQV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 12:21:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60892 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbZHOQV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 12:21:28 -0400
Date: Fri, 14 Aug 2009 18:33:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC][PATCH 0/3] PM: Asynchronous suspend and resume
Message-ID: <20090814163310.GE1626@ucw.cz>
References: <200908122218.13975.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908122218.13975.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The following patches introduce a mechanism allowing us to execute device
> drivers' suspend and resume callbacks asynchronously during system sleep
> transitions, such as suspend to RAM.  The idea is explained in the [1/1] patch
> message.

it looks sane to me... Not too long and nice code :-)
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
