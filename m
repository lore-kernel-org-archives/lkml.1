Return-Path: <linux-kernel-owner+w=401wt.eu-S1758576AbXK0KRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758576AbXK0KRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 05:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754323AbXK0KRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 05:17:16 -0500
Received: from il.qumranet.com ([82.166.9.18]:46377 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbXK0KRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 05:17:15 -0500
Message-ID: <474BEF28.9010005@qumranet.com>
Date: Tue, 27 Nov 2007 12:19:20 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: carsteno@de.ibm.com
CC: Eric Van Hensbergen <ericvanhensbergen@us.ibm.com>,
       kvm-devel@lists.sourceforge.net, lguest <lguest@ozlabs.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org
Subject: Re: [kvm-devel] [PATCH 3/3] virtio PCI device
References: <11944899922822-git-send-email-aliguori@us.ibm.com>	<11944900141678-git-send-email-aliguori@us.ibm.com>	<11944900152750-git-send-email-aliguori@us.ibm.com>	<11944900163817-git-send-email-aliguori@us.ibm.com>	<4742F6B7.20503@qumranet.com>	<474300AD.4060509@us.ibm.com>	<4743076F.8000105@qumranet.com>	<47435CCB.1050506@us.ibm.com>	<4743DAA4.70800@qumranet.com>	<4747051C.3090903@us.ibm.com> <4747122F.1070905@qumranet.com>	<474B1BF3.20901@us.ibm.com> <474BDD28.7050801@qumranet.com> <474BDEDE.6060603@de.ibm.com> <474BE319.502@qumranet.com> <474BEDAB.3000305@de.ibm.com>
In-Reply-To: <474BEDAB.3000305@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Carsten Otte wrote:
>
>> [actually thinking a bit, this is specific to the virtio pci binding; 
>> s390 will never see any of it]
> You remember that we've lost the big debate around virtio in Tucson? 

I was in the embedded BOF.

> We intend to bind our virtio devices to PCI too, so that they look the 
> same in Linux userland across architectures.

Ouch.

-- 
error compiling committee.c: too many arguments to function

