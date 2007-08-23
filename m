Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbXHWHhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbXHWHhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 03:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbXHWHhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 03:37:33 -0400
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:40782 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbXHWHhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 03:37:32 -0400
Date: Thu, 23 Aug 2007 09:36:29 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: postfail@hushmail.com
Cc: <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: Ideas on column length in kernel "problem"?
Message-ID: <20070823093629.032f82aa@localhost>
In-Reply-To: <20070823035442.6FD0DDA81F@mailserver7.hushmail.com>
References: <20070823035442.6FD0DDA81F@mailserver7.hushmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 23:54:41 -0400
"Scott Thompson" <postfail@hushmail.com> wrote:

> if anyone knows of a free/inexpensive mail 
> client that will be able to handle the wordwrap requirements for 
> the current state of the linux tree please advise.

http://www.claws-mail.org/

Configuration -> Preferences -> Wrapping:

"	[x] Auto wrapping
	[ ] Wrap quotation
	[ ] Wrap pasted text

Wrap messages at [..] characters"


Then use the "Insert File" button or (xclip < mypatch.diff && middle
mouse button).

Either will wrap with "Wrap pasted text", so keep it off.


PS: auto wrapping has effect on the text you write directly in the
mailer, you can even turn it off and use "CTRL + L" to wrap the current
paragraph.

-- 
	Paolo Ornati
	Linux 2.6.23-rc3-g2a677896-dirty on x86_64
