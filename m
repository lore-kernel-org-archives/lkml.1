Return-Path: <linux-kernel-owner+w=401wt.eu-S1760122AbYEAMKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbYEAMKs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 08:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756627AbYEAMKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 08:10:40 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:1656 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbYEAMKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 08:10:39 -0400
Date: Thu, 1 May 2008 14:09:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: samuel.thibault@ens-lyon.org, akpm@osdl.org
Subject: This month's price for the most useless new Kconfig help text ...
Message-ID: <20080501120959.GA16700@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 01 May 2008 12:03:11.0023 (UTC) FILETIME=[53832BF0:01C8AB83]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


<drumroll> ... gets CONFIG_ACCESSIBILITY

menuconfig ACCESSIBILITY
        bool "Accessibility support"
        ---help---
          Enable a submenu where accessibility items may be enabled.

One can only guess what is meant by accessbility when asked that 
by oldconfig (don't explain, I know it now) and the help text has about 0% 
additional information over the CONFIG name.

Can the help text be improved please? It should explain that accessibility in 
this case means braille device drivers and possibly other similar devices.

Thanks,

-Andi



