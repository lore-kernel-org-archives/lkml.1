Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbYCVRa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbYCVRa0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 13:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbYCVRaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 13:30:15 -0400
Received: from h155.mvista.com ([63.81.120.155]:10726 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753774AbYCVRaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 13:30:14 -0400
Message-ID: <47E54274.8020805@ru.mvista.com>
Date: Sat, 22 Mar 2008 20:31:32 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/3] ide: add "vlb|pci_clock=" parameter
References: <200803221722.11689.bzolnier@gmail.com>
In-Reply-To: <200803221722.11689.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Add "vlb_clock=" parameter for specifying VLB clock frequency (in MHz).

> * Add "pci_clock=" parameter for specifying PCI bus clock frequency (in MHz).

> While at it:

> * qd65xx.c: rename {active,recovery}_cycle variables to {act,rec}_cyc.

> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
