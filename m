Return-Path: <linux-kernel-owner+w=401wt.eu-S1758885AbYFYPxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbYFYPxd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 11:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754693AbYFYPx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 11:53:27 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:60020 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbYFYPx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 11:53:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=X4b55PemEaZcV98caIWGYFDedONTHOWbAKDxM9K8oa0wquHbWPumYzUYsZCcGrvqjl
         3COgmMFeHtbYNl953J1kzIY12H+5JUbnH/MbfAB1GPiSSSb9izqbDOc6bNIxvgClJqe6
         AqPd5JU1Di27I4vsUbR3jiLxJdAxv15+gNANM=
Message-ID: <d00698fb0806250853t4e28c69aod1bc039296987ad8@mail.gmail.com>
Date: Wed, 25 Jun 2008 17:53:24 +0200
From: noah <noah123@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: apic=debug report for 2.6.24 (32-bit) with Intel 3GHz on MSI 7173
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Motherboard: MSI 7173 Ver 1A
CPU: Intel 3.00GHz (HT enabled)
Kernel 2.6.24 (Ubuntu: linux-image-2.6.24-19-server 2.6.24-19.34) 32-bit

(i wrote this off the screen; i don't have access to a serial console)
SMP alternatives: switching to SMP mcode
Booting processor 1/1 eip 3000
Initializing CPU#1
masked ExtINT ON CPU#1
Calibrating delay using timer specific routine ....
monitor/mwait feature present
CPU: Tracecache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU1: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 0a
Total of 2 processors activated
ENABLING IO-APIC IRQs
..Timer: vector=0x31 apic1=0 pin1=2 apic2=-1 pin=-1
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8295A ... failed
...trying to set up timer as Virtual Wire IRQ ... failed.
...trying to set up timer as ExtINT IRQ ... failed. :(

Booting with noapic works.
