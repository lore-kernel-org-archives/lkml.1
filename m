Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbYAGEC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbYAGEC7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 23:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbYAGECu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 23:02:50 -0500
Received: from hs-out-0708.google.com ([64.233.178.247]:13232 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753036AbYAGECu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 23:02:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ikpKM4dlfvDT00QZIrglfDbWYUrbOCzp23iAcUbKKUKkus52chi3hOldErupLuKNMRMVzp50nMcaMKDWbVFwZAcL6KxFF4ZQ9bcXTMRttdaXTtGI5CohFYJUVcexw9G4NxUzWBwx/M5RSyqQpKcqsRwAXHcQiC1QOhaUwDoUV8E=
Message-ID: <d2a348dd0801062002g762c6946u157790646725cd80@mail.gmail.com>
Date: Sun, 6 Jan 2008 20:02:46 -0800
From: "raki john" <raki4652@gmail.com>
To: "Pierre Ossman" <drzeus@drzeus.cx>
Subject: Replacing drivers/mmc directory in kerenl 2.6.22.1 with drivers/mmc in kernel 2.6.23.1
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Please CC me on your responses

I am working on Kernel 2.6.22.1 mmc host  drivers. I recently found that
mmc driver in kernel 2.6.23.1 supports bounce buffers. I wanted to use
bounce buffer feature.

I do not  want to go to Kernel 2.6.23.1. I want to be at 2.6.22.1, but
I need mmc driver in 2.6.23.1.

Can I replace drivers/mmc directory in 2.6.22.1 with drivers/mmc
directory in 2.6.23.1.   Does this cause any issues. Is there any code
in drivers/mmc in 2.6.23.1 which depends on other features in kernel
2.6.23.1.

Thanks in advance for your help

--
Thanks
raki
