Return-Path: <linux-kernel-owner+w=401wt.eu-S933227AbXGWT3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227AbXGWT3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761177AbXGWT3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:29:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44981 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761329AbXGWT3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:29:35 -0400
Date: Mon, 23 Jul 2007 12:28:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] LinuxPPS - definitive version
Message-Id: <20070723122812.3be807ec.akpm@linux-foundation.org>
In-Reply-To: <1185197716.14697.244.camel@pmac.infradead.org>
References: <20070717180550.GA24759@enneenne.com>
	<1185197716.14697.244.camel@pmac.infradead.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007 14:35:16 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> Please feed it to scripts/checkpatch.pl -- you can ignore all the
> warnings about lines greater than 80 characters, and the complete crap
> about "declaring multiple variables together should be avoided", but
> some of what it points out is valid.

The above are David's opinions.  Many, probably most kernel developers do not
agree with them.

And there are good reasons for ignoring David's opinions here.  To
understand those reasons, try looking at some MTD code.

