Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbYDWIVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbYDWIVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 04:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbYDWIV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 04:21:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:50664 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752338AbYDWIV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 04:21:26 -0400
X-Authenticated: #2025681
X-Provags-ID: V01U2FsdGVkX1/jxB1d6JbjAESAcPfI+Gy5wzilH9OoBioOBpraft
	b4op3EJOWFPKTV
Message-ID: <480EF183.8020700@gmx.de>
Date: Wed, 23 Apr 2008 10:21:23 +0200
From: Stefan Sassenberg <stefan.sassenberg@gmx.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: touchscreen/event concept question
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm trying to use a usb touchscreen (urtc1000) but I don't get the 
concept of the drivers and the event stuff.

I downloaded the 2-6-25 kernel because of the newly integrated driver 
for the very model I want to use, usbtouchscreen. In the XF86Config file 
I additionally need to specify a driver, but I don't have an idea which 
one. I read about people using evtouch, but I don't know why and I don't 
know which /dev/... node to use. I think it has to do with event nodes 
and evdev is loaded, too.

Furthermore, I don't know how to suppress a mouse driver that processes 
events without suppressing my real hardware mouse.

I hope, my questions are making enough sense to you to see my problem. 
Is there someone to explain some of those things?

Stefan
