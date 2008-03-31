Return-Path: <linux-kernel-owner+w=401wt.eu-S1756493AbYCaPJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbYCaPJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 11:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbYCaPJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 11:09:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:14000 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbYCaPJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 11:09:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Y4Q9iWgglIh3vlP4+ctCfw2sHqkyEnsfB+kyOBUsvrl3eQpLUThpAuID6EjW3PEpAcdhAf1t3cahHDugsNvWvuWP3fzugzRIL6KzKv7mZ10qXt68PUv6OdRbOE76dwTZrQfWd2g3tMCpxLwXV6ifAU0czbSFQczq6PTRz+OTq0s=
Message-ID: <12848a3b0803310809v3b995f86p8421fb7f48026006@mail.gmail.com>
Date: Mon, 31 Mar 2008 18:09:42 +0300
From: "Vaida Bogdan" <vaida.bogdan@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Some files needed from post regarding "r8169 backporting for 2.4.35"
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I've seen this post on LKML:
http://linux.derkeiler.com/Mailing-Lists/Kernel/2005-03/8389.html that
had some links to patches backported to 2.4 for the r8169 driver which
doesn't work well with our NICs. It seems mii-tool and ethtool can't
check if the link is up. Could someone send me the patches (or a link
to them)?

  Quote from your mail to LKML:
  "
  Patch against 2.4.29/2.4.30-rc3:
  - http://www.fr.zoreil.com/~romieu/misc/20050326-2.4.29-r8169-test.patch

  Patch-script directory (65 patches):
  - http://www.fr.zoreil.com/linux/kernel/2.4.x/2.4.29/r8169/

  Patch-script tarball:
  - http://www.fr.zoreil.com/linux/kernel/2.4.x/2.4.29/r8169-blob.tar.bz2
  "

  Thanks in advance,
   Vaida Bogdan
