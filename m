Return-Path: <linux-kernel-owner+w=401wt.eu-S1752433AbXCLXsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbXCLXsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 19:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbXCLXsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 19:48:51 -0400
Received: from cheltenham.cs.arizona.edu ([192.12.69.60]:3878 "EHLO
	cheltenham.cs.arizona.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbXCLXsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 19:48:50 -0400
Date: Mon, 12 Mar 2007 16:48:47 -0700
From: Phil Kaslo <phil@cs.arizona.edu>
Message-Id: <200703122348.l2CNmlAg001085@osprey.cs.arizona.edu>
To: lkml@rtr.ca
Subject: Re: Asus P5B-VM motherboard:  cd drive malfunctions if internal nic in use.
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It is a pata cd drive, attached to the JMicron controller.

I'll look into whether the usb ports power off on shutdown.

Thanks,

Phil
