Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbYFBP07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbYFBP07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 11:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbYFBP0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 11:26:52 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:44072 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbYFBP0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 11:26:51 -0400
Message-ID: <48441138.90503@skyrush.com>
Date: Mon, 02 Jun 2008 09:26:48 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: David Newall <davidn@davidnewall.com>, Willy Tarreau <w@1wt.eu>,
       Harald Dunkel <harald.dunkel@t-online.de>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@redhat.com>
Subject: Re: 2.6.25.3: su gets stuck for root
References: <48434D57.6030801@skyrush.com>	<48438126.3080308@t-online.de>	<20080602053256.GF5609@1wt.eu>	<20080602091016.571dda7c@core>	<4843B6EE.8080104@davidnewall.com> <20080602102033.63e4cd18@core>
In-Reply-To: <20080602102033.63e4cd18@core>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Someone who can dup this needs to instrument it in tty_ioctl really.

Alan, since I can get it to happen faithfully, I can try this - any
suggestions on where to instrument?

	Thanks, Joe

P.S.  My stty process sits in "T" - did you say that it would be in "R"
if straced and that is correct?
