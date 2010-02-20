Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab0BTXa1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 18:30:27 -0500
Received: from legolas.restena.lu ([158.64.1.34]:38018 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804Ab0BTXaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 18:30:25 -0500
Date: Sun, 21 Feb 2010 00:10:49 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [Patch 0/3] backlight
Message-ID: <20100221001049.2f63f5d6@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series improves backlight_ops's check_fb function, marks
backlight_ops as const and fixes error checking when registering
backlight device.

Bruno
