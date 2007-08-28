Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbXH1OuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbXH1OuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 10:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbXH1Ot6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 10:49:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:23000 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbXH1Ot6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 10:49:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=dqqWowKwtU3wyBAbr2LWKEc/KRR5rqS4MNCvQoqYTCtqZnl1hSVEPEx3nzVuBS18jJwd/qohUyX75PBwlbGLGSdMYGBbkywRd9RCo1B+3O1Cjwds2dk529e+aiKaEnj4ZBNr3uLL+WaBtuyZ7v/KdSXvMj4inUtzyvKakH9323I=
Message-ID: <ab40e9c0708280749o1d2d4872m3b7688e36d717c6c@mail.gmail.com>
Date: Tue, 28 Aug 2007 16:49:55 +0200
From: "Xu Yang" <risingsunxy@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: lowlevel_init.c
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

i am trying to run linux on realview_eb_mpcore.
I read some articles about how to port linux and uboot to a new board,
according to the article, when I am porting the uboot, i should modify
a file called lowlevel_init.c , which is in the fold
board/realview_eb. this file describes the memory partition of the
board. but in the realview_eb , this file doesn't do this job.
anyone can tell me , where is it done?

without doing this, the file system can be booted or not?

any comments are appreciated.

regards,

yang
