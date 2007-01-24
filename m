Return-Path: <linux-kernel-owner+w=401wt.eu-S932156AbXAXUp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbXAXUp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 15:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932629AbXAXUp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 15:45:58 -0500
Received: from pne-smtpout2-sn1.fre.skanova.net ([81.228.11.159]:49584 "EHLO
	pne-smtpout2-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932156AbXAXUp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 15:45:58 -0500
To: gd@spherenet.de
Cc: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20-rc5: known unfixed regressions (v3) (part 2)
References: <Pine.LNX.4.64.0701121424520.11200@woody.osdl.org>
	<20070124154725.GK17836@stusta.de>
From: Peter Osterlund <petero2@telia.com>
Date: 24 Jan 2007 21:45:53 +0100
In-Reply-To: <20070124154725.GK17836@stusta.de>
Message-ID: <m3y7nsi266.fsf@telia.com>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> writes:

> Subject    : pktcdvd fails with pata_amd
> References : http://bugzilla.kernel.org/show_bug.cgi?id=7810
> Submitter  : gd@spherenet.de
> Status     : unknown

Does reverting this patch help?

http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=406c9b605cbc45151c03ac9a3f95e9acf050808c

If not, I don't know what to suggest except "git bisect". I don't have
the hardware you are using and the backtrace doesn't give any clues.

-- 
Peter Osterlund - petero2@telia.com
http://web.telia.com/~u89404340
