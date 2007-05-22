Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbXEVHkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbXEVHkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 03:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755494AbXEVHkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 03:40:13 -0400
Received: from mo-p07-ob.rzone.de ([81.169.146.188]:29981 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359AbXEVHkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 03:40:11 -0400
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 May 2007 03:40:11 EDT
User-Agent: Microsoft-Entourage/11.2.3.060209
Date: Tue, 22 May 2007 09:33:29 +0200
Subject: TCP_MD5 and Intel e1000
From: Marc Donner <webmaster@poweraudio.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <C2786969.24B46%webmaster@poweraudio.de>
Thread-Topic: TCP_MD5 and Intel e1000
Thread-Index: AcecQ33CvDdGVwg2EdyXfAANk8k/lA==
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-RZG-AUTH: lUESeo99iNzPSpfVSRL8ggQHlJzHbS43qHjjXoZLc8mZA0KYOoCDTp/L9+MmuBIXxOs0QlR8cQ==
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have tried to set up quagga with tcp-md5 support from kernel. All seems ok
with a intel e100 NIC, but as i testetd with a intel e1000 NIC the tcp
packets have an invalid md5 digest.
If i run tcpdump on the mashine the packets are generated, it shows on the
outgoing interface invalid md5 digests.
Are there known issues about tcp-md5 and e1000 NICs?

Regards 
Marc


