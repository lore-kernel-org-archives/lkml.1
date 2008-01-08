Return-Path: <linux-kernel-owner+w=401wt.eu-S1759469AbYAHQsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469AbYAHQsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757289AbYAHQsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:48:04 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:60755 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655AbYAHQsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:48:01 -0500
Message-ID: <4783A904.9030705@s5r6.in-berlin.de>
Date: Tue, 08 Jan 2008 17:47:00 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Valdis.Kletnieks@vt.edu, Willy Tarreau <w@1wt.eu>,
       Adrian Bunk <bunk@kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
References: <20080106171158.GM20473@parisc-linux.org> <1199640983.5205.65.camel@localhost.localdomain> <20080106183402.GA7906@1wt.eu> <20080106185625.GM2082@does.not.exist> <20080106191044.GA1105@1wt.eu> <20080106195802.GN2082@does.not.exist> <20080106210813.GA10136@1wt.eu> <19438.1199739038@turing-police.cc.vt.edu> <20080107213717.GB16309@parisc-linux.org> <26581.1199747065@turing-police.cc.vt.edu> <20080107231930.GC16309@parisc-linux.org>
In-Reply-To: <20080107231930.GC16309@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> So you're saying that you can't find reliable ways to reproduce problems
> on demand?  Those are some of the lower quality bug reports,

Or those are the more difficult problems.
-- 
Stefan Richter
-=====-==--- ---= -=---
http://arcgraph.de/sr/
