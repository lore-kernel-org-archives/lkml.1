Return-Path: <linux-kernel-owner+w=401wt.eu-S1763695AbZEGWhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763695AbZEGWhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbZEGWhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:37:46 -0400
Received: from mail1007.centrum.cz ([90.183.38.137]:52007 "EHLO
	mail1007.centrum.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbZEGWhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:37:45 -0400
Date: Fri, 08 May 2009 00:37:39 +0200
From: <trekker.dk@centrum.cz>
To: <tuxonice-devel@lists.tuxonice.net>
Cc: <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
X-Mailer: Centrum Mail 5.0
MIME-Version: 1.0
X-Priority: 3
Message-ID: <200905080037.19722@centrum.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <20090507120948.GA1531@ucw.cz>
In-Reply-To: <20090507120948.GA1531@ucw.cz>
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well...

>
>
>To summarise disadvantages:
>
>- only core has 8000 LoC
>- it does stuff that can be easily done in userspace
>     (and that todays distros _do_ in userspace).
>- it duplicates uswsusp functionality.
>- compared to [u]swsusp, it received little testing
>

To summarise advatages - for me tuxonice is the only hibernation method that works.
(Till now I've had 3 machines - no one of them able to resume with in-kernel swsusp.)


>_______________________________________________
>TuxOnIce-devel mailing list
>TuxOnIce-devel@lists.tuxonice.net
>http://lists.tuxonice.net/mailman/listinfo/tuxonice-devel
>

