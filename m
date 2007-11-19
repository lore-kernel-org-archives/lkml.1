Return-Path: <linux-kernel-owner+w=401wt.eu-S1752528AbXKSXlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbXKSXlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 18:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbXKSXlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 18:41:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40652 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbXKSXlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 18:41:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chris Friedhoff <chris@friedhoff.org>
Subject: Re: 2.6.24-rc2 STD with s2disk fails to activate suspended system after loading - now 2.6.24-rc3
Date: Tue, 20 Nov 2007 00:58:29 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20071110221629.1d180480.chris@friedhoff.org> <200711191958.36570.rjw@sisk.pl> <20071119234334.2b955b92.chris@friedhoff.org>
In-Reply-To: <20071119234334.2b955b92.chris@friedhoff.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711200058.29663.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 19 of November 2007, Chris Friedhoff wrote:
> dmesg output is added.
> 
> increasing CONFIG_BLK_DEV_RAM_SIZE from 7777 to 131072 hasn't changed
> the non-functioning of 2.6.24-rc3
> 
> s2disk works with 2.6.23.8 ; I tested 4 cycles in a row, 2 from console
> and 2 from within X

I've attached a patch to the bugzilla entry, please test it.

Thanks,
Rafael
