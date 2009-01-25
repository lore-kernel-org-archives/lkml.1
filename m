Return-Path: <linux-kernel-owner+w=401wt.eu-S1751889AbZAYTmi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbZAYTmi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 14:42:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbZAYTma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 14:42:30 -0500
Received: from ds.netgate.net ([205.214.170.232]:51576 "EHLO ds.netgate.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbZAYTm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 14:42:29 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Jan 2009 14:42:29 EST
Message-ID: <497CBF12.10202@macslab.com>
Date: Sun, 25 Jan 2009 11:35:46 -0800
From: Charles Landau <clandau@macslab.com>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Gateway DX4720-03 apic problem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a new Gateway DX4720-03 PC and have discovered that it won't 
install Fedora 10 unless I give the kernel boot option "noapic" or 
"nolapic".

This system's processor is the Intel Pentium Dual Core E5200.

It would seem that this is either a kernel bug to be fixed, or a 
documentation bug so users of this machine know about the workaround. 
I'll report the bug if someone will tell me how.
