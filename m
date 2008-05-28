Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbYE1Cl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbYE1Cl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 22:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYE1ClS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 22:41:18 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:39181
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752382AbYE1ClS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 22:41:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtMAAFZjPEh8qN9Z/2dsb2JhbAAIrnM
X-IronPort-AV: E=Sophos;i="4.27,552,1204470000"; 
   d="scan'208";a="268985037"
Subject: Latest gpio gumph
From: Ben Nizette <bn@niasdigital.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Nias Digital
Date: Wed, 28 May 2008 12:41:15 +1000
Message-Id: <1211942475.27810.37.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey David,

Have you got a git/quilt repo somewhere with all the latest gpiolib (and
gpio framework) stuff glued in?  I've seen most of it hit -mm but
developing against -mm on (especially on obscure archs like AVR32 as I
do) is always fraught.

Of course I do build and test -mm on avr32 as regularly as I can (and
submit patches for the inevitable munging it's taken) but I don't really
want to develop against it.

Thx,
	--Ben.
