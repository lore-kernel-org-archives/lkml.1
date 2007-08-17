Return-Path: <linux-kernel-owner+w=401wt.eu-S1761712AbXHQLNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761712AbXHQLNF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 07:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbXHQLMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 07:12:55 -0400
Received: from twin.jikos.cz ([213.151.79.26]:39676 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863AbXHQLMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 07:12:55 -0400
Date: Fri, 17 Aug 2007 13:12:50 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Andreas Moroder <andreas.moroder@sb-brixen.it>
cc: linux-kernel@vger.kernel.org
Subject: Re: Unable to handle kernel NULL pointer dereference at 0000000000000001
 RIP
In-Reply-To: <fa3v2o$m16$1@sea.gmane.org>
Message-ID: <Pine.LNX.4.64.0708171311320.2460@twin.jikos.cz>
References: <fa3v2o$m16$1@sea.gmane.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007, Andreas Moroder wrote:

> our SLES production system 2.6.5-7.252-smp #1 SMP Tue Feb 14 11:11:04 
> UTC 2006 x86_64 x86_64 x86_64 stopped with the following messages in the 
> log Is this a known bug in this version and is it solved in the next 
> versions.

Hi,

this is vendor-provided kernel, so this is pretty much offtopic on lkml -- 
please file a bugreport in Novell bugzilla, which is a proper place for 
this.

Thanks,

-- 
Jiri Kosina
