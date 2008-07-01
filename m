Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbYGASS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbYGASS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 14:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYGASSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 14:18:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565AbYGASSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 14:18:47 -0400
Date: Tue, 1 Jul 2008 11:17:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, mchehab@infradead.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v2] Add bt8xxgpio driver
Message-Id: <20080701111755.316194d8.akpm@linux-foundation.org>
In-Reply-To: <200807011234.03933.mb@bu3sch.de>
References: <200807011234.03933.mb@bu3sch.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2008 12:34:03 +0200 Michael Buesch <mb@bu3sch.de> wrote:

> This adds the bt8xxgpio driver.
> The purpose of the bt8xxgpio driver is to export all of the 24 GPIO pins
> available on Brooktree 8xx chips to the kernel GPIO infrastructure.
> 
> This makes it possible to use a physically modified BT8xx card as
> cheap digital GPIO card.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> Please queue this patch for 2.6.27
> 
> I could not find a GPIO maintainer. Neither in the MAINTAINERS file
> nor in any GPIO source file. So I didn't CC any GPIO guy, as I don't
> know who that is. :)

David Brownell (IMO).  David, you might want to raise a MAINTAINERS patch.
