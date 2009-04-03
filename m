Return-Path: <linux-kernel-owner+w=401wt.eu-S1764580AbZDCOoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764580AbZDCOoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756811AbZDCOoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:44:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:55229 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755897AbZDCOoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:44:03 -0400
Subject: Re: [PULL] Firmwares for Conexant cx18, cx23885 and cx 25840
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090403080043.3bfaef02@pedra.chehab.org>
References: <20090403080043.3bfaef02@pedra.chehab.org>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 20:13:35 +0530
Message-Id: <1238769815.2489.9.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mauro,

On Fri, 2009-04-03 at 08:00 -0300, Mauro Carvalho Chehab wrote:
> Hi David,
> 
> Please pull for another series of Conexant firmwares. They are available at:
> 	ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-firmware.git master
> 
> Cheers,
> Mauro

These dvb firmware patches are waiting for your approval to merge main
stream:

1. firmware: convert av7110 driver to request_firmware()
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=9547c1f9d435d73d90a41f83ed22e7f89da2c253

2. Remove fdump tool for av7110 firmware
http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commit;h=95cb15cf0a3d61c7ac12f72ae19f1d636bb28fc8

which tree will be suitable for these patches.

Thanks
--
JSR

