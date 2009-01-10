Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177AbZAJNMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbZAJNMk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 08:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbZAJNMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 08:12:31 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:38060 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbZAJNMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 08:12:30 -0500
Message-ID: <49689EA8.20506@garzik.org>
Date: Sat, 10 Jan 2009 08:12:08 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: todays git: WARNING: at drivers/ata/libata-sff.c:1017	ata_sff_hsm_move+0x45e/0x750()
References: <200901091334.55823.borntraeger@de.ibm.com> <200901101009.13699.borntraeger@de.ibm.com> <20090110104114.633cacd8@lxorguk.ukuu.org.uk> <200901101242.05203.borntraeger@de.ibm.com> <49688B63.5030105@ru.mvista.com> <20090110122130.318cf168@lxorguk.ukuu.org.uk> <20090110130745.GA14049@elte.hu>
In-Reply-To: <20090110130745.GA14049@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 871af12: libata: Add 32bit PIO support

What happens when you back this out?

	Jeff


