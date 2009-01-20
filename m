Return-Path: <linux-kernel-owner+w=401wt.eu-S1760863AbZATQqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760863AbZATQqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 11:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbZATQqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 11:46:21 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:41676 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbZATQqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 11:46:20 -0500
Date: Tue, 20 Jan 2009 17:46:18 +0100
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mattia Dongili <malattia@linux.it>
Subject: Re: [Bug #12494] Sony backlight regression from 2.6.28 to 29-rc
Message-ID: <20090120164618.GD31127@gamma.logic.tuwien.ac.at>
References: <0GOi9pntEoL.A.iGF.B9QdJB@chimera> <2QN7KFic7LG.A.ZGH.j9QdJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2QN7KFic7LG.A.ZGH.j9QdJB@chimera>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mo, 19 Jan 2009, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12494
> Subject		: Sony backlight regression from 2.6.28 to 29-rc

Yes it is.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
DITHERINGTON (n)
Sudden access to panic experienced by one who realises that he is
being drawn inexorably into a clabby (q.v.) conversion, i.e. one he
has no hope of enjoying, benefiting from or understanding.
			--- Douglas Adams, The Meaning of Liff
