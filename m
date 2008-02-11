Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbYBKSmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbYBKSmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 13:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYBKSmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 13:42:05 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:3082 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbYBKSmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 13:42:04 -0500
Date: Mon, 11 Feb 2008 18:42:24 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: bug in checkpatch (on pointers to typedefs?)
Message-ID: <20080211184224.GJ11671@shadowen.org>
References: <20080210143240.GA13317@joi> <20080211102339.GD11671@shadowen.org> <47B0725C.30407@panasas.com> <20080211164046.GI11671@shadowen.org> <47B07EA0.7010708@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B07EA0.7010708@panasas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 06:58:08PM +0200, Benny Halevy wrote:
> OK, but the return type doesn't have to be in the patched line, it could be in
> a synchronization line or even missing if the function has a long multi-line argument
> list.

Ok, I guess thats fair criticism.  Could you check out the current
checkpatch-next (0.14-8-g3737366 or later -9, -10 etc), and see if
that works.  It seems to on the simple examples you sent me :).

Thanks.

-apw
