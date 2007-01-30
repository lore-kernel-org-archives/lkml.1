Return-Path: <linux-kernel-owner+w=401wt.eu-S965609AbXA3PbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965609AbXA3PbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 10:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965612AbXA3PbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 10:31:23 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:37316 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965609AbXA3PbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 10:31:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=uOBOW1yDUc65xGcuxdr2uH1lZDnHnzU3lyV5BCqIo7vEHO2Rtek3uKO+kkbj+P3mnzYFS4hjxueLcVeRKTK0VOxpxhfhJxAaxjMcfmFCiK6WIf1IwpwE+QJdEp7P/hQPIQsoyJtR8w0lYGwfMlKr7k4LeYBzu1wUKzWqW4h0gpI=
Message-ID: <8355959a0701300731i4b5b1f77t527deeb8fc5ad5fd@mail.gmail.com>
Date: Tue, 30 Jan 2007 21:01:20 +0530
From: "Sunil Naidu" <akula2.shark@gmail.com>
To: "Linux kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: Strange XServer (KDE) log out on 2.6.20-rc6 !!
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was working on this test machine with 2.6.20-rc6. There was a
strange X log out (KDE 3.5.x). Three applications were running:
BitTorrent client, Firefox 1.5.8, and KWrite.

Suddenly, there was a log out from my work space (blank-blink for 3-4
seconds duration). Then, KDE log in screen appeared. When I logged in
back, those applications were gone!!

I would like to investigate this issue - whether it's a X bug or
something to do with kernel?. I am not running the Firewall & SELinux
(but, connected to internet).

Any inputs for this pl? This maybe OT for LKML...not sure :(

Thanks,

~Akula2
