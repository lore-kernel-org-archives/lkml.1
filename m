Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbZCVWMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbZCVWMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 18:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756734AbZCVWLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 18:11:13 -0400
Received: from bu3sch.de ([62.75.166.246]:35385 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756720AbZCVWLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 18:11:12 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
Date: Sun, 22 Mar 2009 23:09:57 +0100
User-Agent: KMail/1.9.9
Cc: Rui Santos <rsantos@grupopie.com>,
       Michael =?iso-8859-1?q?B=C3=BCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org
References: <200903041828.49972.m.bueker@berlin.de> <200903222219.50112.mb@bu3sch.de> <20090322220032.GA23091@electric-eye.fr.zoreil.com>
In-Reply-To: <20090322220032.GA23091@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903222309.58116.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 March 2009 23:00:32 Francois Romieu wrote:
> Michael Buesch <mb@bu3sch.de> :
> [...]
> > Thanks a lot. I will try these. Will take some time, because this is a
> > production server and I'll have to take care to not completely bring it
> > down. :)
> 
> Please note that Rui's device identifies as XID 0x3c400c0. Yours may need
> something different (I do not remember seeing the XID in the thread back
> in february).

How do I find out? I don't find "XID" in the kernel log.

-- 
Greetings, Michael.
