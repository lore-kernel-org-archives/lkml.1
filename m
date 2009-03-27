Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbZC0WwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbZC0WwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 18:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757782AbZC0Wvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 18:51:48 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:36139 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756535AbZC0Wvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 18:51:48 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Network died completely in 2.6.29
Date: Fri, 27 Mar 2009 23:51:36 +0100
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903272351.37610.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
upgraded to 2.6.29 today. It appeared to work fine for a couple of hours. But 
suddenly the network stopped. I wasn't even able to ping my local IP. Even 
pinging 127.0.0.1 did not work. There were no errors in dmesg and the system 
appeared to work fine otherwise. Had to reboot (into 2.6.28).

Never seen this before. Anyone with the same problem?

-- 
Ondrej Zary
