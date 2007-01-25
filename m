Return-Path: <linux-kernel-owner+w=401wt.eu-S1030493AbXAYXUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030493AbXAYXUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 18:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030500AbXAYXUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 18:20:12 -0500
Received: from mail.netilla.com ([63.97.64.130]:1703 "EHLO
	aep-us-dc-01.aep-net.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030493AbXAYXUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 18:20:11 -0500
X-Greylist: delayed 859 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jan 2007 18:20:10 EST
Message-ID: <45B937F9.6040803@aepnetworks.com>
Date: Thu, 25 Jan 2007 18:06:33 -0500
From: Fei Liu <feiliu@aepnetworks.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060913)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: linux i386 kernel 2.4.16 2.4.22 scheduling issue?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jan 2007 23:05:51.0184 (UTC) FILETIME=[5B91C500:01C740D5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello group, I have some concern about scheduling issue with 2.4.16 and 
2.4.22 i386 kernel where I see 1200+ interrupts and context switches per 
second through vmstat when machine is under load. Is this behavior 
normal? Is there any know scheduling issue with the above mentioned 
kernel versions?

Thanks,

Fei

