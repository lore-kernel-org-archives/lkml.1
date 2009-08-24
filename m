Return-Path: <linux-kernel-owner+w=401wt.eu-S1752134AbZHXJAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbZHXJAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 05:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbZHXJAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 05:00:14 -0400
Received: from relay.atmel.no ([80.232.32.139]:63984 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939AbZHXJAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 05:00:13 -0400
Date: Mon, 24 Aug 2009 10:59:53 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       AVR32 Linux Kernel <kernel@avr32linux.org>
Subject: [GIT PULL] AVR32 update for 2.6.31
Message-ID: <20090824105953.0865db37@hskinnemoen-d830>
Organization: Atmel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git avr32-arch

to receive the following avr32 fixes.

Ben Nizette (1):
      favr32: improve touchscreen response

Sebastian Andrzej Siewior (2):
      avr32/lib: fix unaligned memcpy()
      avr32/lib: fix unaligned memcpy where len < 4

 arch/avr32/boards/favr-32/setup.c |    4 ++++
 arch/avr32/lib/memcpy.S           |   16 +++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)
