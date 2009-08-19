Return-Path: <linux-kernel-owner+w=401wt.eu-S1752462AbZHSAFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbZHSAFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 20:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbZHSAFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 20:05:19 -0400
Received: from ru.mvista.com ([213.79.90.228]:44583 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750787AbZHSAFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 20:05:18 -0400
Date: Wed, 19 Aug 2009 04:05:19 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] 8250: Now honours baud rate lower bounds
Message-ID: <20090819000519.GA32588@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090702213624.GA23193@oksana.dev.rtsoft.ru>
 <20090702225312.02f78ec4@lxorguk.ukuu.org.uk>
 <20090702223013.GA26960@oksana.dev.rtsoft.ru>
 <20090703103924.45902824@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090703103924.45902824@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 10:39:24AM +0100, Alan Cox wrote:
> > How about this patch down below?
> 
> Thats much better.

Alan, is that patch in your queue? I believe you didn't give up on
8250 maintenance so I don't have to resend it to Greg, correct?

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
