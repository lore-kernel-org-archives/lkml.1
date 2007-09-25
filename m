Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbXIYWYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbXIYWYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 18:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbXIYWX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 18:23:57 -0400
Received: from main.gmane.org ([80.91.229.2]:33439 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbXIYWX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 18:23:57 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: trem <tremyfr@yahoo.fr>
Subject: Re: 2.6.23-rc8-mm1 : wgt634u.c
Date: Wed, 26 Sep 2007 00:23:38 +0200
Message-ID: <46F98A6A.6080906@yahoo.fr>
References: <20070925014625.3cd5f896.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: akpm@linux-foundation.org
X-Gmane-NNTP-Posting-Host: atoulouse-256-1-122-67.w90-45.abo.wanadoo.fr
User-Agent: Thunderbird 2.0.0.6 (X11/20070914)
In-Reply-To: <20070925014625.3cd5f896.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've applied the 2.6.23-rc8-mm1 patch, and I've got a new directory
"mips" at root of my linux source. This directory only contain :
"bcm947xx/wgt634u.c"

I think that this directory "bcm947xx" should be added in "arch/mips"
subdirectory.

regards,
trem


