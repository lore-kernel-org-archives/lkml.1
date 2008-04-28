Return-Path: <linux-kernel-owner+w=401wt.eu-S966316AbYD1UwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966316AbYD1UwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965437AbYD1Uvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:51:55 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:54019 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965711AbYD1Uvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:51:53 -0400
Date: Mon, 28 Apr 2008 22:52:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dontdiff: add modules.order
Message-ID: <20080428205227.GD18248@uranus.ravnborg.org>
References: <20080418151816.GA18030@fluff.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418151816.GA18030@fluff.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 04:18:16PM +0100, Ben Dooks wrote:
> Add modules.order to the list of files that
> shoud be ignored when using diff on a built
> kernel tree.
> 
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> 
> diff -rup linux-2.6.25/Documentation/dontdiff linux-2.6.25-dontdiff/Documentation/dontdiff
> --- linux-2.6.25/Documentation/dontdiff	2008-04-17 09:48:05.000000000 +0100
> +++ linux-2.6.25-dontdiff/Documentation/dontdiff	2008-04-18 16:16:45.000000000 +0100
> @@ -142,6 +142,7 @@ mkprep
>  mktables
>  mktree
>  modpost
> +modules.order
>  modversions.h*
>  offset.h
>  offsets.h

Applied this and the other.

	Sam
