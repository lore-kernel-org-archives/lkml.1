Return-Path: <linux-kernel-owner+w=401wt.eu-S1030729AbXBOTTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030729AbXBOTTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030728AbXBOTTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:19:48 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:55377 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030729AbXBOTTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:19:47 -0500
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <930B9C2E-DCE3-4E9E-AA6B-2C58E16736B2@kernel.crashing.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: kbuild question
Date: Thu, 15 Feb 2007 13:18:52 -0600
To: Sam Ravnborg <sam@ravnborg.org>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was wondering if there was some way to make a Kconfig menu either  
be just a menu or a choice depending on another bool being set or not.

What I'm trying to accomplish is if CONFIG_ONLY_HAVE_ONE is set I  
want it so you can only select on option, however if  
CONFIG_ONLY_HAVE_ONE is not set you should be able to select multiple  
options.

thanks

- k
