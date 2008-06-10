Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbYFJVLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbYFJVLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbYFJVLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:11:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754157AbYFJVLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:11:24 -0400
Date: Tue, 10 Jun 2008 14:10:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Steve French" <smfrench@gmail.com>
Cc: jlayton@redhat.com, marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: Fwd: [patch (for 2.6.26?) 1/1] cifs: fix oops on mount when
 CONFIG_CIFS_DFS_UPCALL is enabled
Message-Id: <20080610141058.cacc4fa8.akpm@linux-foundation.org>
In-Reply-To: <524f69650806101014r6a068a7dvacb7fba58a230a63@mail.gmail.com>
References: <200806092348.m59NmsZd015641@imap1.linux-foundation.org>
	<524f69650806100947g4392b44es12b800e39a406d75@mail.gmail.com>
	<524f69650806101014r6a068a7dvacb7fba58a230a63@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008 12:14:26 -0500
"Steve French" <smfrench@gmail.com> wrote:

> From: "Steve French" <smfrench@gmail.com>

argh.  smfrench@gmail.com == sfrench@us.ibm.com == sfrench@samba.org.

This always bugs me because I never know which is preferred, most
reliable, least likely to get mangled, etc.


> To: "Jeff Layton" <jlayton@redhat.com>, marcin.slusarz@gmail.com, "Andrew Morton" <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>
> Subject: Fwd: [patch (for 2.6.26?) 1/1] cifs: fix oops on mount when CONFIG_CIFS_DFS_UPCALL is enabled
> Date: Tue, 10 Jun 2008 12:14:26 -0500
> 
> I don't have the original note (ie patch without whitespace mangled by
> the mailers) that I can ack to Linus on this but would like it merged
> into mainline as an individual patch (my cifs-2.6.git tree has
> additional patches in it that I don't want to merged into
> linux-2.6.git yet).
> 

I'll send this on to Linus and stable@kernel.org in my next batch.

> ---------- Forwarded message ----------
> From: Steve French <smfrench@gmail.com>
> Date: Tue, Jun 10, 2008 at 11:47 AM
> Subject: Re: [patch (for 2.6.26?) 1/1] cifs: fix oops on mount when
> CONFIG_CIFS_DFS_UPCALL is enabled
> To: akpm@linux-foundation.org
> Cc: sfrench@us.ibm.com, marcin.slusarz@gmail.com, sfrench@samba.org,
> stable@kernel.org
>
> ACK

Please don't top-post.  It really does make it hard to keep things
vaguely coherent?

