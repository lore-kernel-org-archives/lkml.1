Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbZGBJTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbZGBJTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 05:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755152AbZGBJTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 05:19:23 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47113 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbZGBJTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 05:19:22 -0400
X-Greylist: delayed 1161 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jul 2009 05:19:22 EDT
Message-ID: <4A4C770F.6000709@bull.net>
Date: Thu, 02 Jul 2009 10:59:59 +0200
From: xb <xavier.bru@bull.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Xeon 5500 series support in kernel
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I wonder if there are specific kernel configuration parameters that 
allow to optimize performances on the recent Xeon 5500 processors (aka 
Nehalem).
In particular, should we set CONFIG_GENERIC_CPU or CONFIG_MCORE2 on such 
processors ?
Thanks in advance.
Xavier
