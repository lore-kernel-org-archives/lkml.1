Return-Path: <linux-kernel-owner+w=401wt.eu-S933977AbXDBL5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933977AbXDBL5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 07:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933980AbXDBL5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 07:57:25 -0400
Received: from mx.laposte.net ([81.255.54.16]:12876 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933977AbXDBL5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 07:57:24 -0400
Message-ID: <56464.192.54.193.51.1175515024.squirrel@rousalka.dyndns.org>
Date: Mon, 2 Apr 2007 13:57:04 +0200 (CEST)
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
From: "Nicolas Mailhot" <nicolas.mailhot@laposte.net>
To: "Li Yu" <raise.sail@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
User-Agent: SquirrelMail/1.4.8-4.fc6
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Er, I also want to know what are drawbacks of "flip-flopping" ?

This will cause major havoc as soon as hot-plugging and apps listening to
HAL events (xorg eventually) enter in play.

-- 
Nicolas Mailhot

