Return-Path: <linux-kernel-owner+w=401wt.eu-S1758401AbZLGS12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401AbZLGS12 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758230AbZLGS10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:27:26 -0500
Received: from senator.holtmann.net ([87.106.208.187]:55222 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943AbZLGS1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:27:25 -0500
Subject: Re: [RESEND #2] [PATCH] Bluetooth: implement raw output for hidp
From: Marcel Holtmann <marcel@holtmann.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       Brian Gunn <bgunn@solekai.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.0912071853230.3755@pobox.suse.cz>
References: <alpine.LNX.2.00.0912031450400.3755@pobox.suse.cz>
	 <alpine.LNX.2.00.0912071853230.3755@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Dec 2009 19:27:12 +0100
Message-ID: <1260210432.2987.59.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

> Implment raw output callback which is used by hidraw to send raw data to 
> the underlying device.
> 
> Without this patch, the userspace hidraw-based applications can't send 
> output reports to HID bluetooth devices.

that is in the bluetooth-next and net-next tree already. Linus should be
pulling it any time soon.

Regards

Marcel


