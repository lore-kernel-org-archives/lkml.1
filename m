Return-Path: <linux-kernel-owner+w=401wt.eu-S1759970AbYB1Q2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970AbYB1Q2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 11:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527AbYB1Q2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 11:28:30 -0500
Received: from gw.c1.byte.nl ([82.94.214.64]:57374 "EHLO smtp.byte.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751708AbYB1Q23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 11:28:29 -0500
Date: Thu, 28 Feb 2008 17:28:28 +0100 (CET)
From: Allard Hoeve <allard@byte.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: Scheduler lockup or nfsd problem in 2.6.24.2 and 2.6.23.17?
In-Reply-To: <Pine.LNX.4.62.0802281452240.1709@office2.c1.internal>
Message-ID: <Pine.LNX.4.62.0802281728080.30703@office2.c1.internal>
References: <Pine.LNX.4.62.0802281452240.1709@office2.c1.internal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The last few days our trusty NFS server has experienced several soft lockups. 
> These occur every 11 hours or so. The system does not respond afterwards. 
> Sending sysrq commands over the serial console seems to work allthough we had 
> to powercycle the server once.

PS: The server is under heavy load almost continuously.

Allard
