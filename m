Return-Path: <linux-kernel-owner+w=401wt.eu-S1761494AbXHFHx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761494AbXHFHx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 03:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758286AbXHFHxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 03:53:45 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:32710 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245AbXHFHxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 03:53:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=SnE0Y3aUmEDUgYkv/EDFEMC3jhC59z9D4K5qZ7Qq1E/Z9NuEm8zk1HCjA1nW691f8dlHtVL0WY5itJYSSNPgl7AyZMbmZwHp3ArkkfY8GLEmwF1f3R1MU1TnBvzuItiHHcfEX71YssDibBSkAIrvefOhIazhJ6JxDeyizcFFvko=
Message-ID: <b4e196fa0708060053x65f0b1d3m50c62206cb65e016@mail.gmail.com>
Date: Mon, 6 Aug 2007 17:53:44 +1000
From: "Nathan Williams" <ngwilliams@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: MODULE_LICENSE usage
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm working on a driver for an ADSL modem which requires the use of a
binary library from the chipset manufacturer.  All my source code is
GPL, so that others are free to distribute and modify the driver.
After asking the FSF for advice and working through their FAQ, I've
given permission for the binary library file to be used with the GPL
source code and be re-distributed with it.

I would like to know if I'm permitted to use MODULE_LICENSE("GPL") in my module.

Additionally, I'm unsure of what is the meaning of

"GPL and additional rights"     [GNU Public License v2 rights and more]

Is it correct to say that my driver is licensed under GPL with
additional rights to use the binary library file?

Thank you,
Nathan
