Return-Path: <linux-kernel-owner+w=401wt.eu-S1757800AbZAVTWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800AbZAVTWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 14:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423AbZAVTWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 14:22:44 -0500
Received: from gate.crashing.org ([63.228.1.57]:57838 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182AbZAVTWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 14:22:44 -0500
Cc: Pierre Ossman <drzeus-sdhci@drzeus.cx>, Ben Dooks <ben-linux@fluff.org>,
       Arnd Bergmann <arnd@arndb.de>, Liu Dave <DaveLiu@freescale.com>,
       Xie Xiaobo <X.Xie@freescale.com>, Konjin Lai <Konjin.Lai@freescale.com>,
       "Joe D'Abbraccio" <Joe.D'abbraccio@freescale.com>,
       sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Message-Id: <5FF82BD4-AA84-4645-A703-F146C226F07C@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
In-Reply-To: <20090122020041.GJ11492@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH 10/10] mmc: Add OpenFirmware bindings for SDHCI driver
Date: Thu, 22 Jan 2009 13:15:01 -0600
References: <20090122015649.GA6835@oksana.dev.rtsoft.ru> <20090122020041.GJ11492@oksana.dev.rtsoft.ru>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 21, 2009, at 8:00 PM, Anton Vorontsov wrote:

> This patch adds a new driver: sdhci-of. The driver is similar to
> the sdhci-pci, it contains common probe code, and controller-specific
> ops and quirks.
>
> So far there are only Freescale eSDHC ops and quirks.
>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
> drivers/mmc/host/Kconfig    |   10 ++
> drivers/mmc/host/Makefile   |    1 +
> drivers/mmc/host/sdhci-of.c |  274 ++++++++++++++++++++++++++++++++++ 
> +++++++++
> 3 files changed, 285 insertions(+), 0 deletions(-)
> create mode 100644 drivers/mmc/host/sdhci-of.c

Still griping about lack of OF binding docs for this.

:)

- k

