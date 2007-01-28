Return-Path: <linux-kernel-owner+w=401wt.eu-S1751859AbXA1LrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbXA1LrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 06:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbXA1LrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 06:47:20 -0500
Received: from nz-out-0506.google.com ([64.233.162.231]:13192 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbXA1LrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 06:47:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=qsb3G1NaC+UswMrOcPyrUTL7dnxwJ8AIlBcpyPIP9XQr+9SNl55Nox5xYv9xTCGFawAqEdZWCo4eLTUrPYCF2+7zztNS7URBEl61/XZEVm6Kb3CBkGDAluojKZjxoJGsyX7Hg7VpGevtYtnHtPcwH5u0t9qom4MZ2roEXB9SBDw=
Message-ID: <8d158e1f0701280347l1d778528la0d69647726485d6@mail.gmail.com>
Date: Sun, 28 Jan 2007 12:47:18 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Boot problems with pata_via driver
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With kernel 2.6.19 I was able to boot using the pata_via driver
I tried to compile 2.6.20-rc6 and now I get a "unknown device: sda3"
error when I try to boot.

I compiled 2.6.20-rc6 by copying over the .config from the 2.6.19 tree
and running a make oldconfig && make

Am I doing something wrong?


Patrick
