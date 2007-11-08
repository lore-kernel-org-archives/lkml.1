Return-Path: <linux-kernel-owner+w=401wt.eu-S1761310AbXKHQAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761310AbXKHQAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 11:00:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759983AbXKHP7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 10:59:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51162 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759479AbXKHP7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 10:59:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Weiner <hannes-kernel@saeurebad.de>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: 2.6.24-rc1: OOPS at  acpi_battery_update
Date: Thu, 8 Nov 2007 17:16:59 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Michael (rabenkind) Brandstetter" <listen@selfservix.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <1193652664.22149.4.camel@localhost> <200711050118.34610.rjw@sisk.pl> <20071108155344.GA12231@cataract>
In-Reply-To: <20071108155344.GA12231@cataract>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711081717.00421.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 8 of November 2007, Johannes Weiner wrote:
> Hi,
> 
> is there any reason, why acpi_battery_get_property() should call
> acpi_battery_update() at all?

Alex?
