Return-Path: <linux-kernel-owner+w=401wt.eu-S1759764AbYHOUuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759764AbYHOUuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 16:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbYHOUuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 16:50:13 -0400
Received: from mtaout2.012.net.il ([84.95.2.4]:50859 "EHLO mtaout2.012.net.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbYHOUuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 16:50:13 -0400
Date: Fri, 15 Aug 2008 23:50:10 +0300
From: Leonid Podolny <leonidp.lists@gmail.com>
Subject: CPU load after killing iwlagn with RF kill switch
X-012-Sender: leonid99@012.net.il
To: linux-kernel@vger.kernel.org
Message-id: <48A5EC02.4070303@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 2.0.0.16 (X11/20080727)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
With a new iwlagn driver and 2.6.27-rc3, if I turn off the wireless 
(intel 4965ag) by RF kill switch, the CPU utilization of ksoftirqd 
process raises to 100% and stays there until I rmmod the module.
Please let me know what further information I can provide.
