Return-Path: <linux-kernel-owner+w=401wt.eu-S1756962AbXGBTJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbXGBTJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 15:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbXGBTJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 15:09:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:42823 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbXGBTJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 15:09:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=DqpnkDTv/qe39oRX0n9UYQbRjU3JZY/axELzez5KxiPAYs7QMfULYWClbAB61M4HNgB1d8hoIFEYrhn2pwlzmblMW+GmZRdhonRBXrhN0uvGYyUMpch/2uQ7jiXO5cD9QSHNCWiIVhZuVG90YqVgAdN3VWAL2wxGbj3xf+Zw5+c=
Message-ID: <a9e22dff0707021209i13718d72p84160c4d3ff89e4@mail.gmail.com>
Date: Mon, 2 Jul 2007 22:09:49 +0300
From: "Ni@m" <niam.niam@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: pci hidden behind transparent bridge
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi! I noticed such message:

"PCI: Bus #07 (-#0a) is hidden behind transparent bridge #06 (-#06)
(try 'pci=assign-busses')
Please report the result to linux-kernel to fix this permanently"

on my
Linux niam 2.6.22-rc6-cfs-v18 #6 Mon Jul 2 20:19:25 EEST 2007 i686
Intel(R) Celeron(R) M processor 1.50GHz GenuineIntel GNU/Linux

What does it mean??
