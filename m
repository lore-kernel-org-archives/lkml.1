Return-Path: <linux-kernel-owner+w=401wt.eu-S1751354AbZL1AML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354AbZL1AML (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 19:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbZL1AMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 19:12:10 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:23646 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZL1AMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 19:12:09 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAJ6GN0urR7Ht/2dsb2JhbAC9C5QYhDME
X-IronPort-AV: E=Sophos;i="4.47,460,1257120000"; 
   d="scan'208";a="457325390"
From: Roland Dreier <rdreier@cisco.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@osdl.org
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
References: <200912271003.631128760@firstfloor.org>
	<1261949800.25298.18.camel@wall-e>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 27 Dec 2009 16:12:06 -0800
In-Reply-To: <1261949800.25298.18.camel@wall-e> (Stefani Seibold's message of
	"Sun, 27 Dec 2009 22:36:40 +0100")
Message-ID: <adahbrcyn1l.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Dec 2009 00:12:06.0951 (UTC) FILETIME=[6412EB70:01CA8752]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > I am not happy to see you to take over my project. Especial as most of
 > your fixes are part of my new macro based implementation. Have a look at
 > http://patchwork.kernel.org/patch/69093/

I don't really understand.  You spent a lot of time getting the kfifo
stuff merged, and now you want to merge (quoting from that patch above)
"a complete reimplementation of the new kfifo API"?

What happened here?  Couldn't you have done the reimplementation before
merging?

 - R.
