Return-Path: <linux-kernel-owner+w=401wt.eu-S1422720AbXCBCpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422720AbXCBCpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 21:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422721AbXCBCpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 21:45:40 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36322 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422720AbXCBCpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 21:45:39 -0500
Date: Thu, 1 Mar 2007 18:45:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: 2.6.21-rc2 radeon backlight
Message-Id: <20070301184531.b3aeafe3.akpm@linux-foundation.org>
In-Reply-To: <87ps7uutsk.fsf@sycorax.lbl.gov>
References: <87ps7uutsk.fsf@sycorax.lbl.gov>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007 08:32:43 -0800
Alex Romosan <romosan@sycorax.lbl.gov> wrote:

> the backlight on my thinkpad still (2.6.20 worked fine) doesn't come
> on if i have the radeon backlight enabled. without it, i guess it's
> the ibm acpi modules that controls the backlight and it seems to work
> fine.
> 

Unclear.  Are you saying that the backlight comes on OK if you use the IBM
acpi module?

