Return-Path: <linux-kernel-owner+w=401wt.eu-S1161187AbXDQRdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161187AbXDQRdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 13:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161195AbXDQRdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 13:33:09 -0400
Received: from hammerhead.shentel.net ([204.111.1.228]:54290 "EHLO
	hammerhead.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161194AbXDQRdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 13:33:07 -0400
Date: Tue, 17 Apr 2007 13:31:53 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: Andreas Schwab <schwab@suse.de>
cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] general: convert "kernel" subdirectory to UTF-8
In-Reply-To: <jefy6yvrj0.fsf@sykes.suse.de>
Message-ID: <alpine.DEB.0.83.0704171330070.914@sigma.j-a-k-j.com>
References: <alpine.DEB.0.83.0704171317580.914@sigma.j-a-k-j.com>
 <jefy6yvrj0.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I can't get my mail client to send in ISO-8859-1 instead of UTF-8, so the 
> 
> Actually your mail is encoded in iso-8859-15.

Is it? I've sent a bajillion test messages to myself and they all ended up 
UTF-8, meaning it actually recursively encoded the original UTF-8 in the 
message.

I'm using alpine. Know any way to explicitly set another encoding such 
that it does -not- get converted on the other end? I tried the 
character-set and charset options but they didn't help at all.
