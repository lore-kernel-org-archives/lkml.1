Return-Path: <linux-kernel-owner+w=401wt.eu-S1751096AbZI1EH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751096AbZI1EH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 00:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbZI1EHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 00:07:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:36063 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbZI1EHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 00:07:25 -0400
Subject: Re: Status of Regression/Bug 13407 adb trackpad disappears after
 suspend to ram?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Martin Wache <m.wache@gmx.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <1254108467.8421.3.camel@pasglop>
References: <4ABF5432.9020508@gmx.net> <200909271713.44719.rjw@sisk.pl>
	 <4ABFAA82.2040200@gmx.net>  <1254108467.8421.3.camel@pasglop>
Content-Type: text/plain
Date: Mon, 28 Sep 2009 13:29:07 +1000
Message-Id: <1254108547.8421.4.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-28 at 13:27 +1000, Benjamin Herrenschmidt wrote:

> Start with sending the dmesg, the output of cat /proc/cpuinfo, and the
> Xorg log (/var/log/Xorg.0.log)

Also throw in your .config (and while at it, try using the standard
pmac32_defconfig).

Cheers,
Ben.


