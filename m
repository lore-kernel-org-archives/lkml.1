Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbYJXXAC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbYJXXAC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 19:00:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYJXW7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 18:59:54 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:42915 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbYJXW7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 18:59:53 -0400
X-IronPort-AV: E=Sophos;i="4.33,481,1220227200"; 
   d="scan'208";a="95950984"
From: Roland Dreier <rdreier@cisco.com>
To: Jeff Becker <Jeffrey.C.Becker@nasa.gov>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, akpm <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, general@lists.openfabrics.org,
       Jeff Squyres <jsquyres@cisco.com>
Subject: Re: [ofa-general] Re: [PATCH] maintainers: moderated mailing list
References: <20081023183805.92bc39ab.randy.dunlap@oracle.com>
	<adabpxarofg.fsf@cisco.com> <4901F249.1030206@nasa.gov>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 24 Oct 2008 15:59:41 -0700
In-Reply-To: <4901F249.1030206@nasa.gov> (Jeff Becker's message of "Fri, 24
	Oct 2008 09:05:29 -0700")
Message-ID: <ada7i7xsioy.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Oct 2008 22:59:42.0134 (UTC) FILETIME=[3325B560:01C9362C]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Currently, I run the mail server. We switched to moderated lists in
 > mid-August due to a huge increase in spam.

It was just that one backscatter flood targeting the ewg list, right?

It's really annoying to people trying to report bugs etc to get the
bounce about subscribers-only lists.  Would it make sense to move the
hosting of the general list to vger.kernel.org, since they have a lot
more resources/experience as mail admins and seem to be able to run open
but relatively spam-free lists?

 - R.
