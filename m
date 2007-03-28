Return-Path: <linux-kernel-owner+w=401wt.eu-S1752368AbXC1RrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbXC1RrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 13:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965164AbXC1RrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 13:47:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55669 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbXC1RrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 13:47:07 -0400
From: Christian <christiand59@web.de>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm2
Date: Wed, 28 Mar 2007 19:42:10 +0200
User-Agent: KMail/1.9.6
References: <20070326211627.c681af3b.akpm@linux-foundation.org>
In-Reply-To: <20070326211627.c681af3b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703281942.10367.christiand59@web.de>
X-Provags-ID: V01U2FsdGVkX1+7e4Gknn+t0O3PMbUiWsOfPzp+KhTgvWFOofO
 aQOBw+HgvhIBtzoET2jNHLvZm7ef4CFZmXmOSwaGb7dw43hfjZ
 LZsv7tFSDkEb0TJ3WMHiA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello lkml!

I have a problem with the new cpuidle infrastructure. My system locks up hard 
on bootup with the message ACPI cpuidle could not initialize cpu0 and cpu1. 
When I deselect cpuidle in the kernel config everything works fine again.
My system is AMD64 X2 with NForce4 chipset.

-Christian
