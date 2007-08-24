Return-Path: <linux-kernel-owner+w=401wt.eu-S933778AbXHXTKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778AbXHXTKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 15:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933368AbXHXTJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 15:09:46 -0400
Received: from smtp3.hushmail.com ([65.39.178.135]:63545 "EHLO
	smtp3.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291AbXHXTJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 15:09:44 -0400
Date: Fri, 24 Aug 2007 15:09:35 -0400
To: <jesper.juhl@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: Ideas on column length in kernel "problem"?
Reply-to: postfail@hushmail.com
From: "Scott Thompson" <postfail@hushmail.com>
Content-type: text/plain; charset="UTF-8"
Message-Id: <20070824190941.144A6C381C@mailserver10.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 23 Aug 2007 08:27:09 -0400 Jesper Juhl 
<jesper.juhl@gmail.com> wrote:
>
>At least for gmail the wrap problem only exists if you try and use 
>the
>web interface for sending your patches. If you use a real mail 
>client
>like pine, kmail etc to send your patches through gmail (and 
>remember
>to use their read/insert file functionality instead of 
>cut'n'paste)
>then there is no problem.

I submitted a patch via gmail/smtp after setting the following up 
and all looked well...

gmail --> settings --> forwarding and pop --> enable pop.

directions for setting up thunderbird:
Thunderbird 1.5
http://mail.google.com/support/bin/answer.py?answer=38343

configuring Thunderbird for wordwrap:
Edit -> Preferences -> Composition
Wrap Plain Text Messages at: 99999

.... and that's it...

I'm gathering up a list of free email clients + settings and will 
post a link once a copy is up on the interweb.

---------------------------------------
Scott Thompson / postfail@hushmail.com
---------------------------------------

