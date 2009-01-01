Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbZAAUiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbZAAUiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 15:38:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbZAAUh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 15:37:59 -0500
Received: from smtp.tal.de ([81.92.1.5]:49580 "EHLO smtp.tal.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbZAAUh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 15:37:59 -0500
From: ib@wupperonline.de (Ingo Brueckl)
Date: Thu, 01 Jan 2009 21:37:00 +0100
Subject: x86 (Linux Tiny): configure out support for some processors
X-Mailer: blueMail 1.4 (SlipDoor 2.2)
Message-ID: <495d2974@wupperonline.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any reason why CONFIG_PROCESSOR_SELECT is limited to EMBEDDED only?

In my desktop pc is one specific cpu only, so I do not need support for the
other processors. Unfortunately, I have no chance to disable the other ones.

As it is already configurable, why not giving this option to everyone?
