Return-Path: <linux-kernel-owner+w=401wt.eu-S938248AbXG0WVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938248AbXG0WVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 18:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938160AbXG0WUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 18:20:42 -0400
Received: from main.gmane.org ([80.91.229.2]:37309 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936762AbXG0WUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 18:20:41 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: Problems with reading DVD using 2.6.21.5
Date: Sat, 28 Jul 2007 00:25:14 +0200
Message-ID: <f8dr30$bqj$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: pd9e42fe5.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de-AT; rv:1.8.1.5) Gecko/20070723 FirefoxSucks/9 SeaMonkey/1.1.3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

today I've tried to install Slackware 12.0

As the installer just "skipped" some install steps, I tried to find the 
error.

The problem seems to be unreadable parts on the DVD:

http://pastebin.com/f381e8a88

But the DVD is OK. I've checked the MD5sum directly from disc on the 
same system using the same DVD drive.

dmesg says:

http://pastebin.com/f63c5c389

The kernel, used on the Slackware setup disk, uses SMP, but my hardware 
doesn't support this (get error on dmesg). May this (SMP kernel on 
non-SMP system) cause such bugs?

Is this a known bug? How could code, which breaks DVD access, get into 
stable 2.6.21.5?

Thanks very much in advance

CU

Manuel

