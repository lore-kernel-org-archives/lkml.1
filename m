Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbYJVHmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbYJVHmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 03:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbYJVHlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 03:41:51 -0400
Received: from inhex.net ([193.33.178.145]:45680 "EHLO inhex.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742AbYJVHlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 03:41:50 -0400
Date: Wed, 22 Oct 2008 10:41:49 +0300
From: Dmitry Nezhevenko <dion@inhex.net>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: Strange ACPI errors sometimes after resume from s2disk
Message-ID: <20081022074149.GA6066@laptop.local>
References: <20081021220034.GA18248@laptop.local> <200810220044.01259.rjw@sisk.pl> <48FED672.4060008@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FED672.4060008@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 11:29:54AM +0400, Alexey Starikovskiy wrote:
> Please try changing msleep(1) to udelay(50) in drivers/acpi/ec.c

Ok. Will try this. However as I said issue is not easy to reproduce.. So
I'll just change it and wait a bit.

> have msi-laptop module loaded?

No. I don't use it.

> Please fill a bugreport and attach all the information there.

Ok. Will do this soon
 
-- 
WBR, Dmitry
