Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbXDZW44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbXDZW44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 18:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbXDZW44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 18:56:56 -0400
Received: from [70.254.190.220] ([70.254.190.220]:55890 "EHLO server.willdawg"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755176AbXDZW4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 18:56:55 -0400
Date: Thu, 26 Apr 2007 22:56:54 +0000 (GMT)
From: William Heimbigner <icxcnika@mar.tar.cc>
X-X-Sender: icxcnika@server.thyself
To: linux-kernel@vger.kernel.org
Subject: Question re config_cmdline
Message-ID: <Pine.LNX.4.64.0704262255170.25153@server.thyself>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that many of the architectures have support for CONFIG_CMDLINE (which 
allows for the configuration of a default kernel command lines), however, x86 
doesn't. Is this intentional, and if so, why? It seems to me that a built in 
command line would be architecture-independent.

William Heimbigner
icxcnika@mar.tar.cc
