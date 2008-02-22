Return-Path: <linux-kernel-owner+w=401wt.eu-S936825AbYBVWsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936825AbYBVWsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936726AbYBVWrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:47:55 -0500
Received: from host64.cybernetics.com ([70.169.137.4]:4219 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S936304AbYBVWrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:47:53 -0500
Message-ID: <47BF5129.3070304@cybernetics.com>
Date: Fri, 22 Feb 2008 17:48:09 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: markh@compro.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: New 2.6.24.2 SG_IO SCSI problems
References: <47BD9588.9080803@compro.net> <47BEFD4B.9060803@cs.wisc.edu> <47BEFF5F.9020002@cs.wisc.edu> <47BF0CE2.306@compro.net> <47BF40D7.5050301@compro.net> <47BF4BD0.7080008@cs.wisc.edu>
In-Reply-To: <47BF4BD0.7080008@cs.wisc.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I attached a backport of the patch from Tony (added as cc) that is in 
> 2.6.25-rc2. Could you try it out against 2.6.24.2 just to make sure it 
> was this patch, then we can send it to stable.
>   

Yes, I had wanted to send this patch to -stable, but got distracted with
other bugs.  So please do so, by all means.

Tony

