Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934330Ab0CKS0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:26:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37367
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756797Ab0CKS00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:26:26 -0500
Date: Thu, 11 Mar 2010 10:26:46 -0800 (PST)
Message-Id: <20100311.102646.06576136.davem@davemloft.net>
To: grant.likely@secretlab.ca
Cc: monstr@monstr.eu, gregkh@suse.de, benh@kernel.crashing.org,
       akpm@linux-foundation.org, sfr@canb.auug.org.au, jgarzik@pobox.com,
       ben-linux@fluff.org, dwmw2@infradead.org, jeremy.kerr@canonical.com,
       James.Bottomley@suse.de, broonie@opensource.wolfsonmicro.com,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux-ide@vger.kernel.org, netdev@vger.kernel.org,
       linux-i2c@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
       linux-scsi@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 00/27] Clean up of_platform drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100311181604.13103.30088.stgit@angua>
References: <20100311181604.13103.30088.stgit@angua>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Grant you've just posted two enormous patch sets at the SAME EXACT
TIME to the SAME AREAS of the kernel.

One has 37 patches and this one has 27.

Not only are these sets enormous, you haven't specified what in the
world they are against.

The 37 patch set didn't apply cleanly to Linus tree and once I worked
through the rejects as best I could it didn't even compile.

How are people supposed to test this stuff? :-/
