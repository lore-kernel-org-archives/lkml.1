Return-Path: <linux-kernel-owner+w=401wt.eu-S937542AbZAPVAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937542AbZAPVAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 16:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759068AbZAPVAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 16:00:10 -0500
Received: from main.gmane.org ([80.91.229.2]:48295 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755670AbZAPVAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 16:00:08 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Angel Tsankov" <fn42551@fmi.uni-sofia.bg>
Subject: How to install asm/page.h
Date: Fri, 16 Jan 2009 22:56:35 +0200
Message-ID: <gkqsa0$e2r$1@ger.gmane.org>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 78.90.132.133
X-MSMail-Priority: Normal
X-Newsreader: Microsoft Outlook Express 6.00.3790.3959
X-RFC2646: Format=Flowed; Original
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4325
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I'm trygin to install Perl 5.8.7 and it requires the asm/page.h file.  I 
found several page.h files in include/asm-* directories (speaking of linux 
2.6.28).  However, make headers_install does not install any of them.  The 
host, target and build platform is the one and the same --  
i686-pc-linux-gnu.  Why is the page.h file not installed?

Regards,
Angel Tsankov 



