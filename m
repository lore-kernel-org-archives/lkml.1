Return-Path: <linux-kernel-owner+w=401wt.eu-S964830AbZLGRRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964830AbZLGRRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964814AbZLGRRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:17:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49002 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964797AbZLGRRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:17:41 -0500
Date: Mon, 7 Dec 2009 09:17:40 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Al Viro <viro@ftp.linux.org.uk>
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/19] untangling do_mremap(), part 1
In-Reply-To: <E1NHUdk-0007ul-Oc@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.0912070911290.3560@localhost.localdomain>
References: <E1NHUdk-0007ul-Oc@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al, 
 just checking: do you think this is ready for merging now? The lack of 
RFC seems to imply it is, but I don't see the Ack's from David from your 
previous series, for example.

		Linus
