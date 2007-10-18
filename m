Return-Path: <linux-kernel-owner+w=401wt.eu-S1765005AbXJRQgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765005AbXJRQgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 12:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756813AbXJRQgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 12:36:22 -0400
Received: from jaguar.mkp.net ([192.139.46.146]:54921 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006AbXJRQgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 12:36:21 -0400
To: Adrian Bunk <bunk@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] pata_cs5536.c: fix array overrun
From: "Martin K. Petersen" <mkp@mkp.net>
Organization: mkp.net
References: <20071018105132.GI3778@stusta.de>
Date: Thu, 18 Oct 2007 12:36:20 -0400
In-Reply-To: <20071018105132.GI3778@stusta.de> (Adrian Bunk's message of "Thu\, 18 Oct 2007 12\:51\:32 +0200")
Message-ID: <yq1sl48752z.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Adrian" == Adrian Bunk <bunk@kernel.org> writes:

Adrian> This patch fixes an obvious array overrun spotted by the
Adrian> Coverity checker.

Bart already posted a patch for this.

-- 
Martin K. Petersen      http://mkp.net/
