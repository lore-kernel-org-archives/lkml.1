Return-Path: <linux-kernel-owner+w=401wt.eu-S1763696AbXIMDyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763696AbXIMDyo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 23:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761420AbXIMDyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 23:54:15 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:49937 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760113AbXIMDyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 23:54:13 -0400
Date: Wed, 12 Sep 2007 20:54:57 -0700
From: Reza Roboubi <reza@parvan.net>
Subject: TCP_LINGER2 TIME_WAIT
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <46E8B491.2080107@parvan.net>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

man 7 tcp says TCP_LINGER2 sets the lifetime of orphaned FIN_WAIT2 state
sockets.  What about wanting to forcibly kill a "rotten" TCP socket in
any other "WAIT" state like TIME_WAIT?

Thanks.

Reza.

