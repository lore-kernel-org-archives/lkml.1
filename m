Return-Path: <linux-kernel-owner+w=401wt.eu-S1756487AbYCKBRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbYCKBRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 21:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYCKBRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 21:17:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754851AbYCKBRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 21:17:31 -0400
Date: Mon, 10 Mar 2008 18:16:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB fixes for 2.6.25-rc5 git
In-Reply-To: <20080311004232.GC17890@suse.de>
Message-ID: <alpine.LFD.1.00.0803101815130.5896@woody.linux-foundation.org>
References: <20080311004232.GC17890@suse.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 10 Mar 2008, Greg KH wrote:
>
> Here are some USB fixes against your 2.6.25-rc5 git tree.

Hmm. You don't seem to have actually pushed these changes out. I get 
"Already up-to-date." when I pull from your usb tree, and as far as I can 
tell, that tree ahs v2.6.25-rc5 as its top-of-tree..

		Linus
