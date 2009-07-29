Return-Path: <linux-kernel-owner+w=401wt.eu-S1752026AbZG2OIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbZG2OIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 10:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbZG2OIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 10:08:43 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:44888 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbZG2OIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 10:08:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:from:to:subject:date:mime-version:content-type
         :content-transfer-encoding:x-priority:x-msmail-priority:x-mailer
         :x-mimeole;
        b=HolmQN7HL9mntbqANmdli4Swx4S48bcM+VKq8igqyuiKasMoz/0hlhtpMg7FeoIf9l
         BfNdpxxs50QYxtWFRDnRlH/7896gUtNjFgNQppiRp8bF6zdyUIH4TXSwkFOMExh0SMU5
         /K0G/ek/pSsnKaJPmQxKRd+7X/6Pv1NASQt+M=
Message-ID: <864C1A9245EB4A3581996E6477890451@HPLAPTOP>
From: "Aaron Gray" <aaronngray.lists@googlemail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Does Linux support Data Exectiion Protection ?
Date: Wed, 29 Jul 2009 15:08:35 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does Linux suppoert DEP, on newer x86 CPU's ?

I am wondering as this does effect alot of VM's using JIT technology if they 
are wriiten without proper code memory allocation. This is a problem for 
StrongTalk and FoNC' IDC. If EP is availiable how configurable is it ?

Many thanks in advance,

Aaron


