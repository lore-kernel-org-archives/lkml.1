Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbXJTNvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbXJTNvR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 09:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbXJTNvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 09:51:00 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:58488 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbXJTNvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 09:51:00 -0400
Subject: Re: [PATCH] bluetooth: hidp core debug code wrong argument fix
From: Marcel Holtmann <marcel@holtmann.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: bluez-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071019050057.GA8734@darkstar.te-china.tietoenator.com>
References: <20071019050057.GA8734@darkstar.te-china.tietoenator.com>
Content-Type: text/plain
Date: Sat, 20 Oct 2007 15:51:54 +0200
Message-Id: <1192888315.6184.113.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> In the debug code of the hidp_queue_report function, the "device" variable does not exist, replace it with "session->hid"

applied to my tree. Thanks.

Regards

Marcel


