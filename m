Return-Path: <linux-kernel-owner+w=401wt.eu-S969114AbXILOYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969114AbXILOYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 10:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966481AbXILOYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 10:24:11 -0400
Received: from mail.fieldses.org ([66.93.2.214]:39050 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966092AbXILOYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 10:24:10 -0400
Date: Wed, 12 Sep 2007 10:24:00 -0400
To: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>
Cc: trond.myklebust@fys.uio.no, netdev@vger.kernel.org,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [NFS] [patch] sunrpc: make closing of old temporary sockets
	work (was: problems with lockd in 2.6.22.6)
Message-ID: <20070912142400.GC24998@fieldses.org>
References: <200709121407.11151.wolfgang.walter@studentenwerk.mhn.de> <20070912133729.GA24998@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912133729.GA24998@fieldses.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 09:37:29AM -0400, bfields wrote:
> So the fact that this changes the behavior means that sk_inuse is taking
> on negative values.

Uh, no, I misread the tests, sorry.  I'm not awake.--b.
