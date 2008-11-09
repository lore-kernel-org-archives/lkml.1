Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbYKIUfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbYKIUfg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbYKIUf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 15:35:26 -0500
Received: from vs02.svr02.mucip.net ([83.170.6.69]:36973 "EHLO
	mailout.mucip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806AbYKIUf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 15:35:26 -0500
Date: Sun, 9 Nov 2008 21:35:21 +0100
From: Bernhard Schmidt <berni@birkenwald.de>
To: Pavel Machek <pavel@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.28-rc3] regression when switching TTY->X, input related?
Message-ID: <20081109203521.GA13683@pest>
References: <20081105220419.GA15685@pest> <20081109135146.GB1730@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081109135146.GB1730@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2008 at 02:51:46PM +0100, Pavel Machek wrote:

> > I think this is a regression because it used to work with the 2.6.27
> > kernel from Ubuntu. I'll try with a vanilla 2.6.27 but I had been
> Yes, please try that. It is possible that ubuntu has some patches in
> and that their userland depens on them...

Will do, it might take me a while to figure out how to boot that ext4
filesystem with ext4dev again :-)

The (most probably) very same bug has been reported in
http://bugzilla.kernel.org/show_bug.cgi?id=11947 and says
"Latest working kernel version: 2.6.27.4".

Bernhard

