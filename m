Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbXLYMfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbXLYMfz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 07:35:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbXLYMfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 07:35:44 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36767 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751549AbXLYMfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 07:35:43 -0500
Date: Tue, 25 Dec 2007 13:33:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/3] PM: Do not destroy/create devices while suspended
	in msr.c
Message-ID: <20071225123352.GB1670@elf.ucw.cz>
References: <200712240155.14765.rjw@sisk.pl> <200712240156.34961.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712240156.34961.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-12-24 01:56:34, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The MSR driver should not attempt to destroy/create a suspended
> device.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
