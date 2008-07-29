Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbYG2CXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbYG2CXW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYG2CXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:23:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:56781 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbYG2CXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:23:08 -0400
Message-ID: <488E7F08.7060309@manoweb.com>
Date: Mon, 28 Jul 2008 19:23:04 -0700
From: Alessio Sangalli <alesan@manoweb.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: interrupt overhead on ARM architecture
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/LgaV7PsbZocN/1QGOY4WhWRzQT56+IabuiP5
 j0itwyn/0cwmM51OlVPnMvMD5j+MWvObn/Ydi2L2K+YYbdcImn
 qw5m3Y3VQPxVg1JyNv1xQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there, I was wondering if somebody ever did some measurements of the
interrupt overhead, measured in clock cycles. Basically how much time it
takes to do the context switch and reach the ISR, and back. My target is
the ARM9...

Thanks
Alessio


