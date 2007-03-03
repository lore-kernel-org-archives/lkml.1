Return-Path: <linux-kernel-owner+w=401wt.eu-S1030280AbXCCOca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030280AbXCCOca (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 09:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030279AbXCCOca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 09:32:30 -0500
Received: from smtp.osdl.org ([65.172.181.24]:37919 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030284AbXCCOc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 09:32:29 -0500
Date: Sat, 3 Mar 2007 06:32:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org, balbir@in.ibm.com, csturtiv@sgi.com,
       daw@sgi.com, guillaume.thouvenin@bull.net, jlan@sgi.com,
       nagar@watson.ibm.com, tee@sgi.com
Subject: Re: [RFC] Documentation for io-accounting / reporting via procfs
Message-Id: <20070303063204.656b321b.akpm@linux-foundation.org>
In-Reply-To: <1661550864@web.de>
References: <1661550864@web.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 03 Mar 2007 15:19:02 +0100 devzero@web.de wrote:

> I have tried to compile some docs for the new and very useful io-accounting feature, mostly by grabbing the existing information from lkml/sources.
> 
> Feel free to comment, modify, ignore - whatever.
> 
> If you like it, maybe this can be merged into Documentation/filesystems/proc.txt  later !?

yup. it looks OK, thanks.

> At it`s current implementation state, it's a bit racy on 32-bit machines: if process 

You have a funny backtick in there where single-quote was intended.  In fact no quote
at all is needed there.
