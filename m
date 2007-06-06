Return-Path: <linux-kernel-owner+w=401wt.eu-S1763588AbXFFKlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763588AbXFFKlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 06:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762813AbXFFKkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 06:40:43 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:37442 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762693AbXFFKkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 06:40:42 -0400
Message-ID: <46668F28.807@free.fr>
Date: Wed, 06 Jun 2007 12:40:40 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PCI MPEG-2 encoder with SDI input in Linux 2.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I work for a small company involved in broadcast.

For the past year, we've been looking for a PCI board that meets
at least the following requirements:

1. Serial Digital Interface input
http://en.wikipedia.org/wiki/Serial_Digital_Interface

2. On-board (hardware) MPEG-2 encoder (our app runs on a low-spec PC) 
which returns a smooth CBR Transport Stream
http://en.wikipedia.org/wiki/Transport_stream

3. Robust Linux 2.6 device driver

AFAIU, the major player in this space is Optibase's MovieMaker 230 
Publisher. AFAICT, they only support 2.4 kernels, and the board is 
overpriced.

I had hoped that Greg Kroah-Hartman's offer would change the landscape, 
but I don't think it has.

At this point, I am definitely open to any and all comments, 
suggestions, and ideas.

Regards.
