Return-Path: <linux-kernel-owner+w=401wt.eu-S1030576AbXD2QzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030576AbXD2QzV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 12:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030792AbXD2QzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 12:55:20 -0400
Received: from web32407.mail.mud.yahoo.com ([68.142.207.200]:23612 "HELO
	web32407.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030576AbXD2QzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 12:55:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=KuI9lpghK6He1pOIpNu/vgKHWvY0kepDWVnBmCxcN1XlXwObxqo0HOTr32XxEmxbZnmWkouwDh+hgWocBNi9qTFCSMXtdfN96rwCP0VCCFeh5nB+0LlVklnMSASbfM5YUl+gvSbpCGiaR91v22GM2hHZpe5NzFki7/iNJvfyHX0=;
X-YMail-OSG: 7PqUPa4VM1lqlwGergMVCjCtTBLRnyLfIpLPAexy6d3qW65EqS9n1wtS1sor66DURTr4BVWWdqiNLPx9iVTyp8PlsMeCFR_ghjXTGwFUDyZRcWUo5xnWC41j7Q--
Date: Sun, 29 Apr 2007 09:55:18 -0700 (PDT)
From: Giridhar Pemmasani <pgiri@yahoo.com>
Subject: Boot failure with 2.6.21 with snd-maestro3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: pgiri@yahoo.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <944251.71448.qm@web32407.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When snd-maestro3 (ESS Maestro 3 driver) is enabled, kernel 2.6.21 fails to
boot - it seems to stop at various points depending on what other modules are
enabled. Disabling snd-maestro3 fixes all issues. Moreover, with everything
else being same, using maestro3.c from 2.6.20 kernel and using it in 2.6.21
kernel also works - i.e., system boots fine. I will try to isolate the issue
and follow up.

Giri

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
