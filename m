Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbZFEGFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbZFEGFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 02:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbZFEGFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 02:05:13 -0400
Received: from newsgw.mentorg.com ([192.94.38.137]:63871 "EHLO
	newsgw.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbZFEGFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 02:05:13 -0400
Message-ID: <4A28B566.1010105@gmail.com>
Date: Fri, 05 Jun 2009 11:34:22 +0530
From: Pranith Kumar <pranith.hacks@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.0.12) Gecko/20070530 Red Hat/1.0.9-2.el4 SeaMonkey/1.0.9
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Are patches for warnings in drivers/staging/* worth?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jun 2009 06:04:22.0802 (UTC) FILETIME=[78ED5720:01C9E5A3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I am looking at the various warnings which occur while compiling the 
staging drivers. Most of them are

* unused variables
* arg makes pointer from integer without cast
* un-initialized variable

What in these warnings should I send patches against? Are they worth the 
effort?

Thanks,
Pranith.
