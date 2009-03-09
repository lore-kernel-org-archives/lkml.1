Return-Path: <linux-kernel-owner+w=401wt.eu-S1752282AbZCIQvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282AbZCIQvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 12:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbZCIQvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 12:51:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:45544 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZCIQvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 12:51:14 -0400
Date: Mon, 9 Mar 2009 07:27:25 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: Dragoslav Zaric <dragoslav.zaric.kd@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux* Processor Microcode Data File
Message-ID: <20090309072725.45a895f1@linux.intel.com>
In-Reply-To: <2d05c4580903090243k6cf73ee9ubb6c4fccf0f07a2f@mail.gmail.com>
References: <2d05c4580903090243k6cf73ee9ubb6c4fccf0f07a2f@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Mar 2009 10:43:57 +0100
Dragoslav Zaric <dragoslav.zaric.kd@gmail.com> wrote:

> Hello,
> 
> I was browsing Intel web site for my processor docs and I bumped
> on download link "Linux* Processor Microcode Data File" and it says
> there:
> 
> "The microcode data file contains the latest microcode definitions for
> all Intel processors.
> Intel releases microcode updates to correct processor behavior as
> documented in the respective
> processor specification updates. While the regular approach to getting
> this microcode update is via
> a BIOS upgrade, Intel realizes that this can be an administrative
> hassle. The Linux Operating System
> and VMware ESX products have a mechanism to update the microcode after
> booting. For example,
> this file will be used by the operating system mechanism if the file
> is placed in the /etc/firmware
> directory of the Linux system."
> 
> So, does new kernel versions just copy this microcode update file in
> /etc/firmware folder

yup just place it there.... and it'll get picked up.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
