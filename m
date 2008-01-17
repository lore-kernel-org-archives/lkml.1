Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbYAQSTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbYAQSTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYAQSTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 13:19:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33297 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbYAQSTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 13:19:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: echo mem > /sys/power/state
Date: Thu, 17 Jan 2008 19:22:09 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org
References: <20080116222445.6f7ff66e.akpm@linux-foundation.org>
In-Reply-To: <20080116222445.6f7ff66e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801171922.10130.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 17 of January 2008, Andrew Morton wrote:
> 
> So I take everyone's latest and greatest product and injudiciously type the
> above command.  The result five minutes later is at
> http://userweb.kernel.org/~akpm/borkage.jpg.  See if you can count all the bugs.
> 
> Sorry, but I've had it with this stuff and I'm tired of fixing everyone else's
> stuff.  I'm just going to ship it.  Good luck.

Like I said in another thread, please try without
pm-acquire-device-locks-on-suspend-rev-3.patch and without git-acpi.patch.
If that still doesn't work, it's not my fault. ;-)
