Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbYHXBC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbYHXBC5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 21:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbYHXBCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 21:02:49 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:50909 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbYHXBCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 21:02:48 -0400
X-Originating-Ip: 216.16.235.2
Date: Sat, 23 Aug 2008 21:02:32 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: Joe Peterson <joe@skyrush.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Visible Ctrl-C in latest kernels
Message-ID: <20080824010231.GA26030@foursquare.net>
References: <20080822201537.GA18242@foursquare.net> <19f34abd0808230253w663722dcwde1303998e194ddf@mail.gmail.com> <48B04E42.3030405@skyrush.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B04E42.3030405@skyrush.com>
User-Agent: Mutt/1.4.1i
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam (whitelisted),
	SpamAssassin (not cached, score=-16.8, required 5,
	autolearn=not spam, ALL_TRUSTED -1.80, BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: <cdfrey@netdirect.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2008 at 11:52:02AM -0600, Joe Peterson wrote:
> Vegard Nossum wrote:
> >> I've noticed that on my Debian stable system, I can now see Ctrl-C characters
> >> when using an xterm.  I've checked the stty settings and nothing seems
> >> different.
> 
> Vegard, thanks for forwarding this to me.
> 
> Chris, yes, what you are now seeing on the newer kernel is correct.

Thanks guys.  I was not aware of this change before asking.  The change
makes sense.  I wasn't having any problems with it, just wondering where
it came from.

Thanks for the enlightenment. :-)

- Chris

