Return-Path: <linux-kernel-owner+w=401wt.eu-S1752859AbYKFRnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbYKFRnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 12:43:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbYKFRnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 12:43:43 -0500
Received: from willie.n0ano.com ([64.66.241.76]:41312 "EHLO xolotl.n0ano.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750917AbYKFRnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 12:43:43 -0500
From: n0ano@n0ano.com
Date: Thu, 6 Nov 2008 10:43:41 -0700
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Is the PCI serial driver code GPL v2 or v3
Message-ID: <20081106174341.GA8155@xolotl.n0ano.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I notice that many of the files that make up the serial driver
are licensed as "either version 2 of the License, or (at your
option) any later version".  Unfortunatley, I would like to use
some of the code from `drivers/serial/8250_pci.c' in grub2,
which is a GPL v3 project, but the copyright for this file
says:

 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License.

The `either' in that sentence would lead me to believe that there
was a typo and the `or later' clause was dropped off but, as it
stands, it's just bad English that says version 2 only.

Anyone know what the true intent was and how to resolve this?

-- 
Don Dugger
"Censeo Toto nos in Kansa esse decisse." - D. Gale
n0ano@n0ano.com
Ph: 303/443-3786
