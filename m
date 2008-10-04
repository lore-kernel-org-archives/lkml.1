Return-Path: <linux-kernel-owner+w=401wt.eu-S1754475AbYJDTpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbYJDTpK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 15:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982AbYJDToy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 15:44:54 -0400
Received: from main.gmane.org ([80.91.229.2]:44472 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938AbYJDTox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 15:44:53 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Thomas Backlund <tmb@mandriva.org>
Subject: Re: [Bug #11615] sata_nv EH problems
Date: Sat, 04 Oct 2008 22:44:42 +0300
Message-ID: <48E7C7AA.2030706@mandriva.org>
References: <0pOgGB.A.uLG.E475IB@wind> <yWwteD.A.kHH.u475IB@wind>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
Cc: kernel-testers@vger.kernel.org
X-Gmane-NNTP-Posting-Host: ndn243.bob.fi
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
In-Reply-To: <yWwteD.A.kHH.u475IB@wind>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki skrev:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11615
> Subject		: sata_nv EH problems
> Submitter	: Pär Andersson <paran@lysator.liu.se>
> Date		: 2008-09-21 18:09 (14 days old)
> Handled-By	: Tejun Heo <tj@kernel.org>
> Patch		: http://bugzilla.kernel.org/attachment.cgi?id=18078&action=view
> 
> 

Merged in:
http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4c1eb90a0908c0c60db2169dce08fb672e7582f1

--
Thomas

