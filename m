Return-Path: <linux-kernel-owner+w=401wt.eu-S940210AbXG3Wik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940210AbXG3Wik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbXG3Wia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:38:30 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53841 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410AbXG3Wi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:38:29 -0400
Message-ID: <46AE6861.50004@garzik.org>
Date: Mon, 30 Jul 2007 18:38:25 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Satyam Sharma <satyam@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Petko Manolov <petkan@users.sourceforge.net>
Subject: Re: [git patches] net driver fixes
References: <20070730212333.GA8049@havoc.gtf.org> <alpine.LFD.0.999.0707310349460.17287@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0707310349460.17287@enigma.security.iitk.ac.in>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

true, we should just remove the dev==NULL check

