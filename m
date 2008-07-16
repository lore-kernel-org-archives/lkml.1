Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYGPRtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYGPRtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 13:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbYGPRte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 13:49:34 -0400
Received: from 216-99-213-120.dsl.aracnet.com ([216.99.213.120]:53039 "EHLO
	clueserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbYGPRte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 13:49:34 -0400
Message-ID: <7445.12.172.32.236.1216230573.squirrel@clueserver.org>
In-Reply-To: <52610.198.182.194.170.1216229551.squirrel@clueserver.org>
References: <52610.198.182.194.170.1216229551.squirrel@clueserver.org>
Date: Wed, 16 Jul 2008 10:49:33 -0700 (PDT)
Subject: Re: Problem mounting Motorola USB device
From: "Alan" <alan@clueserver.org>
To: "Alan" <alan@clueserver.org>
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a-1.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Initializing USB Mass Storage driver...
> scsi6 : SCSI emulation for USB Mass Storage devices
> I have a Motorola phone that mounts as USB storage.  The phone used to
> mount under 2.6.24 on Fedora 8.  Under the latest kernels, however, it
> does not want to mount.  The device gives an odd media error at towards
> the end of the device.  It gave that before, but would still mount.
>
> Does anyone have an idea what is going wrong?

Forgot the kernel version.

Fedora 9 2.6.25.10-86.fc9_x86_64

I am wondering if this is a kernel problem or a udev problem.  Should I
diff the udev rules between f8 and f9?

It appears to be a maze of twisty configs, all alike.
