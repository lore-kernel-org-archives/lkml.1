Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751Ab0AKVsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab0AKVsk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685Ab0AKVsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:48:39 -0500
Received: from mail.elliptictech.com ([209.217.122.41]:34495 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751476Ab0AKVsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:48:38 -0500
Date: Mon, 11 Jan 2010 16:47:10 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Subject: Re: 2.6.33-rc3-git3: Reported regressions from 2.6.32
Message-ID: <20100111214603.GA4335@emergent.ellipticsemi.com>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Adrian Bunk <bunk@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Natalie Protasevich <protasnb@gmail.com>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	Linux ACPI <linux-acpi@vger.kernel.org>,
	Linux PM List <linux-pm@lists.linux-foundation.org>,
	Linux SCSI List <linux-scsi@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	DRI <dri-devel@lists.sourceforge.net>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23:27 Sun 10 Jan     , Rafael J. Wysocki wrote:
> This message contains a list of some regressions from 2.6.32, for which there
> are no fixes in the mainline I know of.  If any of them have been fixed already,
> please let me know.
> 
> If you know of any other unresolved regressions from 2.6.32, please let me know
> either and I'll add them to the list.  Also, please let me know if any of the
> entries below are invalid.

Here are two that I don't see in the list:

 * LVDS downclocking breaks on G45/thinkpad T500

     LKML: http://lkml.org/lkml/2009/12/26/40
     FDO:  http://bugs.freedesktop.org/show_bug.cgi?id=25809
 
 * Receive failure in et131x (Alan Cox sent me a patch for this but
                              it's not in mainline yet)

     LKML: http://lkml.org/lkml/2009/12/29/210

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
