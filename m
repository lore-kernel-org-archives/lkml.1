Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbZIVGE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbZIVGE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 02:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbZIVGE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 02:04:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364AbZIVGE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 02:04:26 -0400
Date: Mon, 21 Sep 2009 23:02:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tomaz Mertelj <tomaz.mertelj@guest.arnes.si>
Cc: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] hwmon: Driver for Texas Instruments 
 amc6821 chip
Message-Id: <20090921230257.1aa1b636.akpm@linux-foundation.org>
In-Reply-To: <5.1.0.14.2.20090922075153.00be9690@pop3.arnes.si>
References: <20090909093435.60531d95@hyperion.delvare>
	<20090905_120834_010267.tomaz.mertelj@guest.arnes.si>
	<20090908170649.855dd1ff.akpm@linux-foundation.org>
	<20090909093435.60531d95@hyperion.delvare>
	<5.1.0.14.2.20090922075153.00be9690@pop3.arnes.si>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009 07:59:14 +0200 Tomaz Mertelj <tomaz.mertelj@guest.arnes.si> wrote:

> Should I post a patch on top of the original patch or a full patch to the 
> latest kernel tree?

Either is OK for me.

I'll turn it into an incremental patch so I can see what you changed.
