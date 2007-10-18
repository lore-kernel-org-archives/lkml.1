Return-Path: <linux-kernel-owner+w=401wt.eu-S1762680AbXJRCV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762680AbXJRCV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 22:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbXJRCVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 22:21:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33412 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbXJRCVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 22:21:18 -0400
Date: Wed, 17 Oct 2007 19:21:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Casey Schaufler <casey@schaufler-ca.com>
cc: Thomas Fricaccia <thomas_fricacci@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: LSM conversion to static interface
In-Reply-To: <900019.22422.qm@web36607.mail.mud.yahoo.com>
Message-ID: <alpine.LFD.0.999.0710171919240.26902@woody.linux-foundation.org>
References: <900019.22422.qm@web36607.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Oct 2007, Casey Schaufler wrote:
> 
> The in-tree vs out-of-tree discussion is independent of LSM.

Indeed. I think there is certainly likely to be some small overlap, but I 
*think* they are largely independent issues - "do we want choice in 
securitu models" (a very emphatic YES as far as I'm concerned) vs "do we 
necessarily want to do them as out-of-tree modules" (I'd like people who 
actually *do* things like that to educate us on why and what they are 
doing).

Hmm?

		Linus
