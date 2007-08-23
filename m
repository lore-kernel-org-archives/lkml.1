Return-Path: <linux-kernel-owner+w=401wt.eu-S1761924AbXHWL5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761924AbXHWL5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 07:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbXHWL4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 07:56:55 -0400
Received: from mx.fr.bfs.de ([194.95.226.137]:52050 "EHLO mail.fr.bfs.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757730AbXHWL4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 07:56:54 -0400
Message-ID: <46CD7600.6020608@bfs.de>
Date: Thu, 23 Aug 2007 13:56:48 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Paolo Ornati <ornati@fastwebnet.it>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: Ideas on column length in kernel "problem"?
References: <20070823035442.6FD0DDA81F@mailserver7.hushmail.com> <20070823093629.032f82aa@localhost>
In-Reply-To: <20070823093629.032f82aa@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Paolo Ornati wrote:
> On Wed, 22 Aug 2007 23:54:41 -0400
> "Scott Thompson" <postfail@hushmail.com> wrote:
> 
>> if anyone knows of a free/inexpensive mail 
>> client that will be able to handle the wordwrap requirements for 
>> the current state of the linux tree please advise.
> 
> http://www.claws-mail.org/
> 
> Configuration -> Preferences -> Wrapping:
> 
> "	[x] Auto wrapping
> 	[ ] Wrap quotation
> 	[ ] Wrap pasted text
> 
> Wrap messages at [..] characters"
> 
> 
> Then use the "Insert File" button or (xclip < mypatch.diff && middle
> mouse button).

xclip converts tabs to space if i remember correctly

re,
 wh




> Either will wrap with "Wrap pasted text", so keep it off.
> 
> 
> PS: auto wrapping has effect on the text you write directly in the
> mailer, you can even turn it off and use "CTRL + L" to wrap the current
> paragraph.
> 
