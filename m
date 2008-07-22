Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbYGVKHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbYGVKHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 06:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbYGVKHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 06:07:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33476 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232AbYGVKHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 06:07:34 -0400
Date: Tue, 22 Jul 2008 03:06:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/4] Char: merge ip2main and ip2base
Message-Id: <20080722030655.1049c2d8.akpm@linux-foundation.org>
In-Reply-To: <20080722104441.3dc7caa1@lxorguk.ukuu.org.uk>
References: <1215264506-32455-1-git-send-email-jirislaby@gmail.com>
	<20080722024458.f609bb12.akpm@linux-foundation.org>
	<20080722104441.3dc7caa1@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2008 10:44:41 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > I applied these four, but there's a fly in our ointment.
> > 
> > On 14 July, Akinobu Mita <akinobu.mita@gmail.com> sent a patch titled
> > "ip2: avoid add_timer() with pending timer" which Alan acked and then
> > claimed was "Queued for ttydev tree".  But afaict he then lost it.
> 
> Its queued but I can unqueue it as it isn't in the pile pending for Linus
> yet.

You've had it queued longer than I've had Jiri's sent-earlier patches
queued :(

I guess if Jiri can redo that patch for us then I can slip all five into
2.6.27-rc1?

