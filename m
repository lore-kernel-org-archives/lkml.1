Return-Path: <linux-kernel-owner+w=401wt.eu-S1756870AbYAGTFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbYAGTFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 14:05:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbYAGTFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 14:05:46 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:55763 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbYAGTFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 14:05:45 -0500
Message-ID: <478277CF.7070808@s5r6.in-berlin.de>
Date: Mon, 07 Jan 2008 20:04:47 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: Willy Tarreau <w@1wt.eu>, Adrian Bunk <bunk@kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       Peter Osterlund <petero2@telia.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
References: <1199316785.3258.85.camel@localhost.localdomain>	<alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org>	<m3ir27oe7f.fsf@telia.com>	<1199627875.5205.1.camel@localhost.localdomain>	<20080106144706.GA25419@elte.hu>	<1199632845.5205.31.camel@localhost.localdomain>	<20080106171158.GM20473@parisc-linux.org>	<1199640983.5205.65.camel@localhost.localdomain>	<20080106183402.GA7906@1wt.eu>	<20080106185625.GM2082@does.not.exist>	<20080106191044.GA1105@1wt.eu> <18306.17536.212405.674762@stoffel.org>
In-Reply-To: <18306.17536.212405.674762@stoffel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stoffel wrote:
> The question to me really revolves around how do you automate the
> process in a transparent manner so that people don't have to change
> much how they interact with lkml.  

I think the more important questions are:
  - Are there people who know how to get reports to developers?
    (We can't train all potential reporters to get reports right.)
  - Are there enough developers to work towards bug fixes?
The technical means to capture reports, let alone the bugtracking tools,
are of secondary importance.
-- 
Stefan Richter
-=====-==--- ---= --===
http://arcgraph.de/sr/
