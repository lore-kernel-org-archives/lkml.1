Return-Path: <linux-kernel-owner+w=401wt.eu-S1754151AbYI2VSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbYI2VSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 17:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYI2VR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 17:17:59 -0400
Received: from eazy.amigager.de ([213.239.192.238]:52424 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbYI2VR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 17:17:59 -0400
Date: Mon, 29 Sep 2008 23:19:04 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Wakeup from suspend via keyboard and mouse doesn't work
	anymore with 2.6.27-rc
Message-ID: <20080929211904.GB3185@dose.home.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-kernel@vger.kernel.org
References: <20080922202911.GA9832@dose.home.local> <200809222309.34413.rjw@sisk.pl> <20080922211844.GA7049@dose.home.local> <200809260035.09052.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809260035.09052.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 00:35:08 +0200, Rafael J. Wysocki wrote:

[...]

> Can you please check if the appended patch restores the previous behavior?

Yes, with this patch wakeup using the keyboard works as it did with
2.6.26.

Thanks and regards,
Tino
