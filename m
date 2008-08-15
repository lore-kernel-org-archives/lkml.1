Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbYHOBDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbYHOBDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 21:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbYHOBCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 21:02:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbYHOBCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 21:02:53 -0400
Date: Thu, 14 Aug 2008 21:02:26 -0400
From: Rik van Riel <riel@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Pavel Machek <pavel@suse.cz>, "Press, Jonathan" <Jonathan.Press@ca.com>,
       davecb@sun.com, Adrian Bunk <bunk@kernel.org>,
       Mihai Don??u <mdontu@bitdefender.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
 access scanning
Message-ID: <20080814210226.71176666@bree.surriel.com>
In-Reply-To: <20080815004335.GF13048@mit.edu>
References: <20080813125638.GB6995@ucw.cz>
	<20080813135207.CC08C3765BC@pmx1.sophos.com>
	<20080814125410.GA2262@elf.ucw.cz>
	<2629CC4E1D22A64593B02C43E855530304AE4BE3@USILMS12.ca.com>
	<20080814223918.GC6370@elf.ucw.cz>
	<20080814200005.6b363716@bree.surriel.com>
	<20080815004335.GF13048@mit.edu>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008 20:43:35 -0400
Theodore Tso <tytso@mit.edu> wrote:

> But Pavel is raising a good question.  In Eric's proposed threat
> model, he claimed the only thing that he was trying to solve was
> "scanning".  Just file scanning.  That implies no root privileges, but
> it also implied that he wasn't worried about malware running with user
> privileges, either.  Presumbly, that would be caught and stopped by
> the file scanner before the malware had a chance to run;

You bring up a very good point - malware does not need to
be stored on a filesystem in order to run or cause damage.

-- 
All rights reversed.
