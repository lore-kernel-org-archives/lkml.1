Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbYHWNSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbYHWNSq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 09:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYHWNSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 09:18:37 -0400
Received: from khc.piap.pl ([195.187.100.11]:33572 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbYHWNSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 09:18:37 -0400
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 22 (hdlc/wanbook)
References: <20080822173415.6958cbcc.sfr@canb.auug.org.au>
	<20080822152059.c83ea19a.randy.dunlap@oracle.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 23 Aug 2008 15:18:34 +0200
In-Reply-To: <20080822152059.c83ea19a.randy.dunlap@oracle.com> (Randy Dunlap's message of "Fri\, 22 Aug 2008 15\:20\:59 -0700")
Message-ID: <m3od3jhnth.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

Randy Dunlap <randy.dunlap@oracle.com> writes:

> wanbook.tmpl was removed!?!  why?
> Is there some replacement for it or is it just not useful?

The latter. wanbook.tmpl was actually syncppp description only, and
syncppp doesn't seem to be surviving.

> I seem to have missed the patch(es) that did this...

http://lkml.org/lkml/2008/8/9/130

> Looks like Documentation/DocBook/Makefile was missed in the patch.

Precisely. Thanks for the info. Fixed now.
-- 
Krzysztof Halasa
