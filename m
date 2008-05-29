Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbYE2SDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbYE2SDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbYE2SDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:03:41 -0400
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4169 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbYE2SDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:03:40 -0400
Message-ID: <483EEFF6.7090002@xs4all.nl>
Date: Thu, 29 May 2008 20:03:34 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: flashing to H2200 ipaq doesn't work: bug or feature? kernel or application?
X-Enigmail-Version: 0.95.2
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

While trying to flash my H2210 ipaq I found out that this doesn't work.
Flashing from LAB (the bootloader) doesn't work but also flashing from
linux (booted from CF card) using mtd-utils doesn't work.
See the bug at:
http://bugs.openembedded.net/show_bug.cgi?id=4324

Does anybody here own a H2200 series ipaq which was flashed successfully
from either LAB or linux using mtd-utils?
Do mtd-utils work for hx2110 ipaqs?

Is the H2200 issue a kernel issue or an application bug?
Please post.

Kind regards,
Udo

