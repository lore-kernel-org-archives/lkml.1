Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbZK2Vwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbZK2Vwv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 16:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbZK2Vwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 16:52:50 -0500
Received: from zfrontend2.aha.ru ([195.2.83.148]:55929 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752750AbZK2Vwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 16:52:50 -0500
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Nov 2009 16:52:50 EST
From: "werner" <w.landgraf@ru.ru>
Subject: pci=off
To: linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Sun, 29 Nov 2009 16:52:50 -0400
Message-ID: <web-96228708@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"werner" <w.landgraf@ru.ru>
In the last time, more and more laptops have problems to 
boot with Linux.

The most frequent problem is that IDE drives are not 
found, or cannot be accessed because reclaimed as ocupied. 
  The only mean to access them and to get it booted, is 
with pci=off.   However, with this, the system becomes 
almost unuseable, lspci also shows nothing.      ITS 
NECESSARY THAT SOMEONE MAKE A KERNEL PARAMETER  pci=noide 
, so that all hardware is registered, with exception of 
ide (and sata) drives   !!!!   This problem, for example, 
also happens on IBM/Lenovo Thinkpad laptops.

A Toshibe Satelite laptop, I need go back to kernel 2.6.23 
. With later kernels, at the beginning of the boot the 
screen become black and nothing more happened.  The same 
happens on that laptop with all newer Slackware kernels

W.Landgraf
---
Professional hosting for everyone - http://www.host.ru
