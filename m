Return-Path: <linux-kernel-owner+w=401wt.eu-S1757654AbYDAIks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654AbYDAIks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 04:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756961AbYDAIke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 04:40:34 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:35241 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639AbYDAIkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 04:40:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=pLpkXtw73Tbb80CZJj2ls6dmO2O//Z/a5MggfaEEfO/jtahFqaiEg5YMQqPSN08p8ocOKck0yzu3PepaQVpKW7xr+QO1qvo8PvM3MbN7uyrOTsyczobW8kC1pkAX4lfSn6IQMATWvALvDZ0xFdun/JZiTcvS6x2nezqRgT9dUTs=
Message-ID: <47F1F4F4.2080502@gmail.com>
Date: Tue, 01 Apr 2008 10:40:20 +0200
From: Luca Venturini <lucventurini@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: New IWL4935 driver for Intel Wireless Cards does not support WPA2
 wireless network with PEAP - MSCHAPV2
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using Ubuntu Hardy Beta, Linux kernel 2.6.24, AMD64.
I have to connect to a campus (University of Verona, Italy; more 
information maybe available at https://wifi.univr.it sadly in Italian 
only, and I am not sure it is reachable from outside the university) 
WPA2 wireless network. It uses PEAP authentication, Dynamic WEP 
encryption, second phase: MSCHAPv2.
It also requires user login, password, and a CA certificate (available 
at the web page I linked above).
At the same page a wpasupplicant configuration file is also available, 
so to allow people to connect from linux also.
In Ubuntu Gutsy 32 bit (Linux kernel 2.6.22.14 if I am not mistaken) I 
was able to connect through NetworkManager and precisely using the GNOME 
nm-applet.
However, since I switched to Linux 2.6.24, I have no more been able to 
connect, whether through NM-applet or from the command line, using 
wpasupplicant. The wireless functions perfectly, and there has been no 
change in its configuration, since I am using it now (Windows Vista, 
configured months ago).
Reported also here on launchpad: 
https://bugs.launchpad.net/ubuntu/+bug/209602
Thank you for your attention.
Greetings

Luca Venturini
