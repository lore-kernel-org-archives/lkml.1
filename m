Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab0BJHVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 02:21:16 -0500
Received: from relay.atmel.no ([80.232.32.139]:59090 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab0BJHVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 02:21:15 -0500
Date: Wed, 10 Feb 2010 12:50:51 +0530
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kernel@avr32linux.org, "Joachim Eastwood" <Joachim.Eastwood@jotron.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] AVR32 fixes for 2.6.33
Message-ID: <20100210125051.6e053769@hskinnemoen-d830>
Organization: Atmel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git master

to receive the following fixes for 2.6.33.

Hans-Christian Egtvedt (1):
      avr32: clean up memory allocation in at32_add_device_mci

Peter Huewe (1):
      arch/avr32: Fix build failure for avr32 caused by typo

 arch/avr32/mach-at32ap/at32ap700x.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)
