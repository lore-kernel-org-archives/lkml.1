Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753979AbYLZSYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbYLZSYf (ORCPT <rfc822;akpm@linux-foundation.org>);
	Fri, 26 Dec 2008 13:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYLZSYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 13:24:07 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41610 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbYLZSYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 13:24:05 -0500
Date: Thu, 1 Jan 1970 07:46:03 +0100
From: Pavel Machek <pavel@suse.cz>
To: Micha? Miros?aw <mirq-linux@rere.qmqm.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci-quirks: HP hides SMBus controller in Compaq nx9500
	laptops
Message-ID: <19700101064603.GA1406@ucw.cz>
References: <20081223215407.GB32525@rere.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081223215407.GB32525@rere.qmqm.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-12-23 22:54:07, Micha? Miros?aw wrote:
> I found no references to SMBus in ACPI DSDT disassembly on my laptop
> so this should be safe.
> 
> Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>

Well, it could still be used by smm bios traps...

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
