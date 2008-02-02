Return-Path: <linux-kernel-owner+w=401wt.eu-S1762247AbYBBPfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762247AbYBBPfH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 10:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757801AbYBBPey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 10:34:54 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:52689 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756528AbYBBPex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 10:34:53 -0500
Date: Sat, 2 Feb 2008 16:34:56 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, jgarzik@pobox.com
Subject: Re: [PATCH] sis190: fix compile error section type conflict
Message-ID: <20080202153456.GA24031@uranus.ravnborg.org>
References: <47A3FF3F.1040908@cn.fujitsu.com> <20080202143458.GA27978@electric-eye.fr.zoreil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202143458.GA27978@electric-eye.fr.zoreil.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 03:34:58PM +0100, Francois Romieu wrote:
> Li Zefan <lizf@cn.fujitsu.com> :
> > Fix the following compile error:
> 
> I am not sure that it is the right fix. Please read the archive of
> this week on l-k.
> 
> I'll submit the patch below to Jeff once I have tested it with real
> hardware (sunday evening entertainment). Sam, is it ok to add your
> s-o-b to it ?
No - a s-o-b document the path of the patch. And it will not hit
Jeff via me. Although I know I said ths was to way to do it.
But you can add my:
Acked-by: Sam Ravnborg <sam@ravnborg.org>

If I posted the patch myself I do not remember - but then the s-o-b
would be correct.

	Sam
