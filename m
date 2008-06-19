Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbYFSWgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbYFSWgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 18:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbYFSWgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 18:36:09 -0400
Received: from 187.Red-80-37-203.staticIP.rima-tde.net ([80.37.203.187]:10955
	"EHLO betty.it.uc3m.es" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752514AbYFSWgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 18:36:07 -0400
From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Message-Id: <200806192235.m5JMZsYD007864@betty.it.uc3m.es>
Subject: Re: zero-copy recv ?
X-ELM-OSV: (Our standard violations) hdr-charset=US-ASCII; no-hdr-encoding=1
To: linux kernel <linux-kernel@vger.kernel.org>
Date: Fri, 20 Jun 2008 00:35:53 +0200 (CEST)
Reply-To: ptb@inv.it.uc3m.es
X-Anonymously-To: 
X-message-flag: Had your Outlook virus, today?
 http://www.counterpane.com/crypto-gram-0103.html#4
X-WebTV-Stationery: Standard\; BGColor=black\; TextColor=black
X-Mailer: ELM [version 2.4ME+ PL123]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

References: <200806191411.m5JEBE56008942@betty.it.uc3m.es>

Gah .. I wrote an answer to this and it seems to have got lost. If you
saw the answer, please forward to me!

> On Thu, Jun 19, 2008 at 04:11:14PM +0200, Peter T. Breuer wrote:
> > I've been mmapping the request's bio buffers received on my block device
> > driver for userspace to use directly as tcp send/receive buffers.
> Is the code available somewhere by any chance?

It's just the daily development snapshot for the enbd driver: 

 ftp://oboe.it.uc3m.es/pub/Programs/enbd-2.4.36.tgz

and mirrors.

I wrote a quick summary of the relevant code in my lost answer :(.
Please ask me to repeat if it is really AWOL.


Peter
