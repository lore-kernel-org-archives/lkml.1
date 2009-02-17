Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbZBQLjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbZBQLjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 06:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZBQLjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 06:39:33 -0500
Received: from smtp.nokia.com ([192.100.105.134]:22057 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbZBQLjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 06:39:32 -0500
From: Felipe Balbi <felipe.balbi@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: 
Date: Tue, 17 Feb 2009 13:18:10 +0200
Message-Id: <1234869491-29630-1-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.6.1.265.g9a013
In-Reply-To: <20090216131426.GU21181@scadufax.research.nokia.com>
References: <20090216131426.GU21181@scadufax.research.nokia.com>
X-OriginalArrivalTime: 17 Feb 2009 11:33:04.0273 (UTC) FILETIME=[7F3A0010:01C990F3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi again Richard,

Here's a new implementation of ledtrig-gpio.c using irq events to trigger
the leds.

I guess it's a better version so the previous one could be forgotten.

Dave, could you check gpiolib part is ok ?

Thanks all,

-- 
balbi

