Return-Path: <linux-kernel-owner+w=401wt.eu-S1757663AbZFAU0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbZFAU0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 16:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbZFAUZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 16:25:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42606 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbZFAUZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 16:25:57 -0400
Date: Mon, 1 Jun 2009 22:20:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Paul Smith <paul@mad-scientist.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] coredump: Retry writes where appropriate
Message-ID: <20090601202033.GA23475@redhat.com>
References: <1243748019.7369.319.camel@homebase.localnet> <20090531111851.07eb1df3@lxorguk.ukuu.org.uk> <20090601161234.GA10486@redhat.com> <1243877766.8547.38.camel@psmith-ubeta.netezza.com> <20090601184934.1fc54411@lxorguk.ukuu.org.uk> <1243881544.8547.66.camel@psmith-ubeta.netezza.com> <20090601200232.078aacbb@lxorguk.ukuu.org.uk> <1243885899.8547.95.camel@psmith-ubeta.netezza.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243885899.8547.95.camel@psmith-ubeta.netezza.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01, Paul Smith wrote:
>
> If it's interactive, can't the user ^Z (SIGSTOP) the process being
> dumped,

No, this is very hard to implement.

Oleg.

