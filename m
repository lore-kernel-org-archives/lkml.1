Return-Path: <linux-kernel-owner+w=401wt.eu-S1752556AbZDVXle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbZDVXle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 19:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbZDVXl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 19:41:26 -0400
Received: from kroah.org ([198.145.64.141]:43913 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbZDVXlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 19:41:25 -0400
Date: Wed, 22 Apr 2009 16:38:28 -0700
From: Greg KH <greg@kroah.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: maximilian attems <max@stro.at>,
       "Christopher J. Harrer" <charrer@alacritech.com>,
       Bernd Porr <BerndPorr@f2s.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] linux-firmware updates
Message-ID: <20090422233828.GA17239@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a1b8f9ee2c559adc85a3a87e8352f451ad4747b4:
  David Woodhouse (1):
        Merge branch 'master' of http://git.decadent.org.uk/git/linux-firmware

are available in the git repository at:

  gregkh@master.kernel.org:/pub/scm/linux/kernel/git/gregkh/linux-firmware.git gregkh

Bernd Porr (2):
      Add usbdux firmware
      Add the source code for the usbdux firmware

maximilian attems (1):
      Alacritech: reword firmware license to be distributable

 WHENCE                         |   16 +-
 usbdux/Makefile_dux            |   19 +
 usbdux/README.dux              |   15 +
 usbdux/fx2-include.asm         |  164 ++++++
 usbdux/usbdux_firmware.asm     | 1184 ++++++++++++++++++++++++++++++++++++++++
 usbdux/usbduxfast_firmware.asm |  547 +++++++++++++++++++
 usbdux_firmware.bin            |  Bin 0 -> 1770 bytes
 usbduxfast_firmware.bin        |  Bin 0 -> 999 bytes
 8 files changed, 1941 insertions(+), 4 deletions(-)
 create mode 100644 usbdux/Makefile_dux
 create mode 100644 usbdux/README.dux
 create mode 100644 usbdux/fx2-include.asm
 create mode 100644 usbdux/usbdux_firmware.asm
 create mode 100644 usbdux/usbduxfast_firmware.asm
 create mode 100644 usbdux_firmware.bin
 create mode 100644 usbduxfast_firmware.bin
