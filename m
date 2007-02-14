Return-Path: <linux-kernel-owner+w=401wt.eu-S932672AbXBNW5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672AbXBNW5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 17:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932673AbXBNW5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 17:57:24 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:20807 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932672AbXBNW5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 17:57:23 -0500
X-IronPort-AV: i="4.14,170,1170662400"; 
   d="scan'208"; a="39568857:sNHT46326483"
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       "Hugh Dickins <hugh@veritas.com> Andrew Morton" 
	<akpm@linux-foundation.org>,
       "Torvalds@linux-foundation.org Torvalds" 
	<torvalds@linux-foundation.org>
Subject: Re: CONFIG_SWAP=n broken in latest tree
X-Message-Flag: Warning: May contain useful information
References: <adak5ykz7jy.fsf@cisco.com>
	<20070214144915.42fa803d.randy.dunlap@oracle.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 14 Feb 2007 14:57:20 -0800
In-Reply-To: <20070214144915.42fa803d.randy.dunlap@oracle.com> (Randy Dunlap's message of "Wed, 14 Feb 2007 14:49:15 -0800")
Message-ID: <adaps8cxs8f.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Feb 2007 22:57:20.0366 (UTC) FILETIME=[7B5C20E0:01C7508B]
Authentication-Results: sj-dkim-5; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim5002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > We've beat this almost to death... just need some patch merged.

Sorry, missed the discussion I guess...
