Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbZADNzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbZADNzm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 08:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbZADNze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 08:55:34 -0500
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:29472 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbZADNze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 08:55:34 -0500
Date: Sun, 4 Jan 2009 14:55:31 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Ingo Molnar <mingo@elte.hu>
cc: Baodong Chen <chenbdchenbd@gmail.com>, linux-kernel@vger.kernel.org,
       trivial@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Subject: [PATCH] Documentation/x86/boot.txt:payload length was
 changed to payload_length
In-Reply-To: <20090104125713.GD15472@elte.hu>
Message-ID: <alpine.LNX.2.00.0901041453170.26359@swampdragon.chaosbits.net>
References: <d204e3110901020024n7d0c1a6dt919f76283d9a8663@mail.gmail.com> <20090102092659.GC1975@elte.hu> <d204e3110901022044l2cf57f54yd52a2d331d69deef@mail.gmail.com> <20090104125713.GD15472@elte.hu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2009, Ingo Molnar wrote:

> 
> * Baodong Chen <chenbdchenbd@gmail.com> wrote:
> 
> > On Fri, Jan 2, 2009 at 5:26 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > >
> > > * Baodong Chen <chenbdchenbd@gmail.com> wrote:
> > >
> > >>  Documentation/x86/boot.txt:payload length was changed to payload_length
> > >>
> > >> Signed-off-by: Baodong Chen <[email]chenbdchenbd@gmail.com[email]>
> > >>
> > >> ---
> > >>  Documentation/x86/boot.txt |    2 +-
> > >>  1 files changed, 1 insertions(+), 1 deletions(-)
> > >
> > > looks good but the patch was whitespace damaged (all tabs were spaces and
> > > there were linewraps as well), please check
> > > Documentation/email-clients.txt and resend the patch. Thanks,
> > >
> > >        Ingo
> > 
> > I referred to Documentation/email-clients.txt:Gmail and resent the 
> > patch. I am a newbie,if i made any mistake,please do me a favor and help 
> > me.Thanks!
> 
> it's OK, and your resubmission was better - but it still had a linewrap 
> problem (i was able to fix that up manually).
> 
> this bit:
> 
> @@ -44,7 +44,7 @@ Protocol 2.07:        (Kernel 2.6.24) Added paravirtualised
> boot protocol.
>                 and KEEP_SEGMENTS flag in load_flags.
> 
> [3 lines]
> 
> should have been:
> 
> @@ -44,7 +44,7 @@ Protocol 2.07:        (Kernel 2.6.24) Added paravirtualised boot protocol.
>                 and KEEP_SEGMENTS flag in load_flags.
> 
> [2 lines]
> 
> If you post from gmail it might make sense to send patches as MIME 
> attachments, we can process them just fine. (as long as you send patches 
> that go via -tip - other maintainers have different policies regarding 
> MIME attachments)
> 
Or simply don't use Gmails web interface for sending the emails.
I used to use Gmail in the past, but I used it with Pine or Alpine most 
of the time. Alpine can be configured to send proper emails and just use 
Gmails SMTP server for sending them - Mutt also works fine.

-- 
Jesper Juhl <jj@chaosbits.net>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html

