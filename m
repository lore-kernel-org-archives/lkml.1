Return-Path: <linux-kernel-owner+w=401wt.eu-S1758737AbZKETNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737AbZKETNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 14:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758612AbZKETNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 14:13:52 -0500
Received: from www.tglx.de ([62.245.132.106]:44559 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758057AbZKETNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 14:13:51 -0500
Date: Thu, 5 Nov 2009 20:13:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: linux-kernel@vger.kernel.org
cc: mm-commits@vger.kernel.org
Subject: Re: mmotm 2009-11-01-10-01 uploaded
In-Reply-To: <200911011807.nA1I7o95016136@imap1.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0911052010050.12138@localhost.localdomain>
References: <200911011807.nA1I7o95016136@imap1.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Nov 2009, akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2009-11-01-10-01 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at

Does "soon" mean within this century ?

>    git://git.zen-sources.org/zen/mmotm.git

# git pull git://git.zen-sources.org/zen/mmotm.git master
git.zen-sources.org[0: 216.98.141.250]: errno=Connection timed out
git.zen-sources.org[0: 69.72.142.98]: errno=Connection refused
fatal: unable to connect a socket (Connection refused)

Thanks,

	tglx
