Return-Path: <linux-kernel-owner+w=401wt.eu-S1752600AbYJXIj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbYJXIj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 04:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbYJXIjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 04:39:17 -0400
Received: from smtp4.netcologne.de ([194.8.194.137]:43602 "EHLO
	smtp4.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbYJXIjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 04:39:15 -0400
Date: Fri, 24 Oct 2008 10:39:13 +0200
From: Max Kellermann <max@duempel.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: Re: High load in 2.6.27, NFS / rpcauth_lookup_credcache()?
Message-ID: <20081024083913.GA15197@squirrel.roonstrasse.net>
Mail-Followup-To: Trond Myklebust <trond.myklebust@fys.uio.no>,
	linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
References: <20081022091207.GA12996@squirrel.roonstrasse.net> <20081023123628.GA18549@squirrel.roonstrasse.net> <1224773745.7625.4.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224773745.7625.4.camel@localhost>
X-Terrorism: FBI NSA CIA Clinton Bush Blair Urane Nuclear Bomb Terror
	Hussein Iraq Iran Syria Plutonium Bin Laden World Trade Center
	Afghanistan Taliban Jaish Rocket Guantanamo Ziercke
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008/10/23 16:55, Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> Can you add a '-v' to the rpc.gssd daemon startup line? I'd like to see
> how often you are creating new gss contexts.

There is no rpc.gssd running on any of these servers, we're using
plain NFSv3 without (protocol based) authentication.  Do you want me
to start it anyway?

Max
