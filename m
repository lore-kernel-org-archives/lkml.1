Return-Path: <linux-kernel-owner+w=401wt.eu-S1761448AbXIUTpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761448AbXIUTpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 15:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762235AbXIUTpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 15:45:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57013 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761406AbXIUTpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 15:45:14 -0400
Date: Fri, 21 Sep 2007 12:44:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, netdev@vger.kernel.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sb1250-mac: Driver model & phylib update
Message-Id: <20070921124409.7f3d122b.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64N.0709191811040.24627@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0709191811040.24627@blysk.ds.pg.gda.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2007 12:52:10 +0100 (BST)
"Maciej W. Rozycki" <macro@linux-mips.org> wrote:

>  A driver model and phylib update.

akpm:/usr/src/25> diffstat patches/git-net.patch | tail -n 1
 1013 files changed, 187667 insertions(+), 23587 deletions(-)

Sorry, but raising networking patches against Linus's crufty
old mainline tree just isn't viable at present.
