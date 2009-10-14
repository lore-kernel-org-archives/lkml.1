Return-Path: <linux-kernel-owner+w=401wt.eu-S1755114AbZJNRoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbZJNRoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 13:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbZJNRox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 13:44:53 -0400
Received: from lucidpixels.com ([75.144.35.66]:36770 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779AbZJNRox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 13:44:53 -0400
Date: Wed, 14 Oct 2009 13:44:16 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: What is eth"X"-Q0?
Message-ID: <alpine.DEB.2.00.0910141343240.23631@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On my new system, cat /proc/interrupts:

  36:          0       3055       2757       1086    1208446      25588 
726447    1028280   PCI-MSI-edge      eth2-Q0
  37:          0          0          0          0          0          0 
3          0   PCI-MSI-edge      eth2
  38:          0     103124          0          0        784   14511559 
6936870   15972334   PCI-MSI-edge      eth1-Q0
  39:          0          0          0          0          2          0 
0          0   PCI-MSI-edge      eth1

What does the "-Q0" stand for, is this because the device was renamed?

Justin.
