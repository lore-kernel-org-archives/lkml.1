Return-Path: <linux-kernel-owner+w=401wt.eu-S1751859AbYJRKZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbYJRKZx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 06:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbYJRKZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 06:25:45 -0400
Received: from mail.papka.lv ([213.180.119.227]:12155 "EHLO mercury.msh.lv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbYJRKZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 06:25:44 -0400
X-Greylist: delayed 1762 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Oct 2008 06:25:44 EDT
Message-ID: <48F9B2BD.8060404@sad.lv>
Date: Sat, 18 Oct 2008 12:56:13 +0300
From: Deniss <dg@sad.lv>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: bug in ipt_recent Netfilter module for 2.4.36 kernel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is the bug in ipt_recent netfilter module in linux kernel 2.4.36.7

Full description of bug can be found here: 
http://blog.blackdown.de/2005/05/09/fixing-the-ipt_recent-netfilter-module/

Please apply following patch to upcoming 2.4. release or backport 
rewritten version from 2.6 branch.

Patch against linux kernel 2.4.36: 
http://dg.sad.lv/files/ipt_recent.2.4.patch

Best,
     Deniss Gaplevsky
