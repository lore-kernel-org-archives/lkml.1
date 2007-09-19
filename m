Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbXISGzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbXISGzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 02:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbXISGzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 02:55:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:55935 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbXISGzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 02:55:08 -0400
Message-ID: <016a01c7fa89$ff51e850$b4fefea9@andrey>
From: "Andrey Kamchatnikov" <andrey.kamchatnikov@tec-venture.de>
To: <linux-kernel@vger.kernel.org>
Subject: Problem: one driver and 4 instances with different parameters
Date: Wed, 19 Sep 2007 08:54:58 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Provags-ID: V01U2FsdGVkX1/8QJBGyboWfhwSJCmyGxCLLeyj+uhFScPGJeR
 u7hNAVX3LdUP1Q7crEadLZ5t906c0uzz4KgmuDaW1fE1v2zvYO
 fn4FIp3ZhFeTJAc4HEKJF5nL/ND8k4B7pCpxH/qSRPt4JD5XO5
 k3g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Could someone to make clear next question:

I have one driver, but I need to run 4 instances of it (I run insmod with 
different parameters) .

But when I try to install the second driver I've got an error, that driver 
with this name exists.

How can I istall them? I don't want to use 4 different driver's sources.

Thank you,

Andrey 

