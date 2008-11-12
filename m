Return-Path: <linux-kernel-owner+w=401wt.eu-S1751844AbYKLHgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbYKLHgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 02:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbYKLHgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 02:36:12 -0500
Received: from eazy.amigager.de ([213.239.192.238]:45987 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbYKLHgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 02:36:11 -0500
Date: Wed, 12 Nov 2008 08:36:17 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [stable] Suspend regression in stable kernel 2.6.27.4 on Mac
	mini Core Duo
Message-ID: <20081112073617.GA4996@dose.home.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-kernel@vger.kernel.org, stable@kernel.org,
	Greg KH <greg@kroah.com>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
	Len Brown <lenb@kernel.org>
References: <20081109202830.GA7206@x61> <20081111181925.GA5036@dose.home.local> <200811120048.06647.rjw@sisk.pl> <200811120103.55253.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811120103.55253.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 01:03:54 +0100, Rafael J. Wysocki wrote:

[...]

> Also, can you check this patch on top of 2.6.27.4 and see what happens?

With that patch, resume works (although I used 2.6.27.5 and not
2.6.27.5, if that matters).

Regards,
Tino
