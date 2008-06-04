Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbYFDDkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbYFDDkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 23:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYFDDkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 23:40:31 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:38067 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbYFDDka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 23:40:30 -0400
Date: Tue, 3 Jun 2008 20:40:30 -0700
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/4] per-task-delay-accounting: add memory reclaim delay
Message-Id: <20080603204030.0f62c2be.kobayashi.kk@ncos.nec.co.jp>
In-Reply-To: <20080604121356.940E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080603193825.12dbfff1.kobayashi.kk@ncos.nec.co.jp>
	<20080604121356.940E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jun 2008 12:15:48 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
> > To: linux-kernel@vger.kernel.org
> > Cc: akpm@linux-foundation.org
> > Subject: [PATCH 1/4] per-task-delay-accounting: add memory reclaim delay
> 
> Why don't you cc'ed delayacct developer nor linux-mm?

Oops. I forgot to add delayacct developer to CC.
I'll do it.

But are you sure about linux-mm?
