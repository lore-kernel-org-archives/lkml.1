Return-Path: <linux-kernel-owner+w=401wt.eu-S966279AbXIBL6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966279AbXIBL6Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 07:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965205AbXIBL6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 07:58:14 -0400
Received: from mi0.bluebottle.com ([206.188.25.15]:35222 "EHLO
	mi0.bluebottle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965345AbXIBL6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 07:58:13 -0400
DomainKey-Signature: a=rsa-sha1; s=mail; d=bluebottle.com; c=nofws; q=dns;
	h=received:from:to:cc:subject:date:mime-version:
	content-type:content-transfer-encoding:x-priority:
	x-msmail-priority:x-mailer:x-mimeole:x-trusted-delivery;
	b=Gr6rmwwFPb4veNiAQcH12pGKbcvLMpEoHuySx5vcXyXeUDu0FtNp1/cYL8BSRTkEh
	yMOlr4+hT1BhwS6/xItG8cYCX1JL1oNUjh08Pj5wmSUf6pXA99gcLRTg4zYWmbm
Message-Id: <200709021158.l82BwCcO013983@mi0.bluebottle.com>
From: "n" <xellos@bluebottle.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, <patrizio.bassi@gmail.com>
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Kernel," <linux-kernel@vger.kernel.org>,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       "Alan Cox" <alan@redhat.com>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Subject: libata / pata drivers and smart , pata_via . pata_pdc202xx_old
Date: Sun, 2 Sep 2007 04:58:11 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="Windows-1252";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Trusted-Delivery: <5177670bec0ce7890a75872964e1ff4d>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

is it possible to get the new libata drivers (pata_via . pata_pdc202xx_old) 
to support smart?
i was looking at smartcrl -a and it says Device does not support SMART even 
though it does.

----------------------------------------------------------------------
Get a free email address with REAL anti-spam protection.
http://www.bluebottle.com/tag/1

