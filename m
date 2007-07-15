Return-Path: <linux-kernel-owner+w=401wt.eu-S1760818AbXGOM5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760818AbXGOM5x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 08:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbXGOM5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 08:57:46 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:57949 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbXGOM5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 08:57:45 -0400
From: Markus <lists4me@web.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: flooding: "new high speed USB device using ehci_hcd and address"
Date: Sun, 15 Jul 2007 14:57:43 +0200
User-Agent: KMail/1.9.5
References: <200707141433.35026.lists4me@web.de>
In-Reply-To: <200707141433.35026.lists4me@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707151457.43320.lists4me@web.de>
X-Provags-ID: V01U2FsdGVkX1/yyRJyWq9MgMFMuQYU+vKQrj9/pJlLEkpHjql/
	XEKhiGbH4DxOHUbqmtc0E+f0G4ZFrsOJMOp81yChnV8fkbKaxp
	R8Ea36KJQ=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I just noticed that the problem might be caused by the process 
disappearance [1], because it does not start right after the boot. And 
needs a random amount of time to appear.

Never mind,
   Markus

[1] http://lkml.org/lkml/2007/07/14/60
