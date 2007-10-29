Return-Path: <linux-kernel-owner+w=401wt.eu-S1758192AbXJ2PTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192AbXJ2PTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbXJ2PTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:19:15 -0400
Received: from ee.oulu.fi ([130.231.61.23]:34819 "EHLO ee.oulu.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503AbXJ2PTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:19:14 -0400
Date: Mon, 29 Oct 2007 17:18:14 +0200
From: Pekka Pietikainen <pp@ee.oulu.fi>
To: Adrian Bunk <bunk@kernel.org>
Cc: jgarzik@pobox.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove Documentation/networking/net-modules.txt
Message-ID: <20071029151813.GA22960@ee.oulu.fi>
References: <20071024162503.GT30533@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071024162503.GT30533@stusta.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 06:25:03PM +0200, Adrian Bunk wrote:
> According to git, the only one who touched this file during the last
> 5 years was me when removing drivers...

That's not the only obsolete thing there:
>  ncsa-telnet
>  	- notes on how NCSA telnet (DOS) breaks with MTU discovery enabled.
And probably others too. Then again, the information there isn't wrong, it's
just totally useless these days :P

-- 
Pekka Pietikainen
