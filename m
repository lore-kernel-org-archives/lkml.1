Return-Path: <linux-kernel-owner+w=401wt.eu-S1758140AbXKTHpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbXKTHpR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 02:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbXKTHpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 02:45:03 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58858
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755375AbXKTHpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 02:45:00 -0500
Date: Mon, 19 Nov 2007 23:45:00 -0800 (PST)
Message-Id: <20071119.234500.127324508.davem@davemloft.net>
To: joe@perches.com
Cc: linux-kernel@vger.kernel.org, wli@holomorphy.com,
       sparclinux@vger.kernel.org
Subject: Re: [PATCH 06/59] arch/sparc: Add missing "space"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1195523331-15303-7-git-send-email-joe@perches.com>
References: <1195523331-15303-6-git-send-email-joe@perches.com>
	<ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
	<1195523331-15303-7-git-send-email-joe@perches.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 19 Nov 2007 17:47:58 -0800

> Signed-off-by: Joe Perches <joe@perches.com>

Please check your patches, for trailing white "space".

Adds trailing whitespace.
diff:10:		prom_printf("PCIC: Error, cannot map " 
Adds trailing whitespace.
diff:19:		prom_printf("PCIC: Error, cannot map " 
warning: 2 lines add whitespace errors.

I've fixed it up this time.
