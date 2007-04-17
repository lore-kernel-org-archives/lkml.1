Return-Path: <linux-kernel-owner+w=401wt.eu-S1161398AbXDQWiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161398AbXDQWiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 18:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161403AbXDQWiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 18:38:52 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:13458 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161398AbXDQWiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 18:38:51 -0400
X-IronPort-AV: i="4.14,420,1170662400"; 
   d="scan'208"; a="412503715:sNHT45798780"
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Tomasz =?iso-8859-1?Q?K=C5=82oczko?= <kloczek@rudy.mif.pg.gda.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Theodore Tso <tytso@mit.edu>,
       "David R. Litwin" <presently42@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
X-Message-Flag: Warning: May contain useful information
References: <op.tqw1g6n0ftfxs2@localhost.localdomain>
	<200704171229.21433.dhazelton@enter.net>
	<Pine.BSO.4.63.0704172045560.11088@rudy.mif.pg.gda.pl>
	<200704171819.28407.dhazelton@enter.net>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 17 Apr 2007 15:38:45 -0700
In-Reply-To: <200704171819.28407.dhazelton@enter.net> (Daniel Hazelton's message of "Tue, 17 Apr 2007 18:19:28 -0400")
Message-ID: <ada647u1v9m.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Apr 2007 22:38:45.0657 (UTC) FILETIME=[288D8890:01C78141]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > After the discussions that took place back around the time of the release of 
 > the first draft of GPLv3 it was decided to lock Linux to *ONLY* GPLv2

This is not accurate.  As far back as I can easily check, the kernel's
COPYING file has said:

 Also note that the only valid version of the GPL as far as the kernel
 is concerned is _this_ particular version of the license (ie v2, not
 v2.2 or v3.x or whatever), unless explicitly otherwise stated.

To be really precise, there was a trivial rewording of this sometime
around Feb 2002 to make it clearer, but the point is that the kernel
has been GPL v2 only long before the GPL v3 process started.

 - R.
