Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYG3TYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYG3TYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbYG3TYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:24:12 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:43956 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbYG3TYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:24:10 -0400
X-IronPort-AV: E=Sophos;i="4.31,281,1215388800"; 
   d="scan'208";a="19050873"
From: Roland Dreier <rdreier@cisco.com>
To: "Miller\, Mike \(OS Dev\)" <Mike.Miller@hp.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LKML-scsi <linux-scsi@vger.kernel.org>
Subject: Re: Problems building 2.6.26 and 2.6.27-rc1
References: <20080730184833.GA936@roadking.ldev.net>
	<adaiqunyyxd.fsf@cisco.com>
	<0F5B06BAB751E047AB5C87D1F77A778826B3E81120@GVW0547EXC.americas.hpqcorp.net>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 30 Jul 2008 12:24:04 -0700
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A778826B3E81120@GVW0547EXC.americas.hpqcorp.net>
	(Mike Miller's message of "Wed, 30 Jul 2008 19:17:08 +0000")
Message-ID: <ada7ib3yy3v.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Jul 2008 19:24:04.0994 (UTC) FILETIME=[D47C4E20:01C8F279]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, doesn't reproduce here with your config and gcc 4.1.

No idea, sorry.

 - R.
