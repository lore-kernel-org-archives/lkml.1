Return-Path: <linux-kernel-owner+w=401wt.eu-S1946144AbXEBBKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946144AbXEBBKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 21:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946128AbXEBBKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 21:10:23 -0400
Received: from web54407.mail.yahoo.com ([206.190.49.137]:36924 "HELO
	web54407.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1946146AbXEBBKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 21:10:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=TgRY0GVS9i4iko3akMmGjCWhiYoFkcwgmKrGKKLLm49SeKIpERP/caOBq8jH3AngJ1qvDXxqEAX82CsgOmO1no/Zr3TKS8vXOLXhMLEEgRIbv/4SlEApMespn4bFzFVSRzL4FjckuQISNjFZEZcqTYkq6eLeMoJ9uD2aqSNJkiw=;
X-YMail-OSG: WOIL7aYVM1k69x2zuY645thQM2XSvbPTMvgha_C48CkhzgPmzwqOmv8CxR9Zqe4rz8_hvcn0ovxh4yvNKIZQmOfnow3Xa7fXbjNNgJhgKTZ46sp_4MggNRPKKqd7
Date: Tue, 1 May 2007 18:10:19 -0700 (PDT)
From: Vlad <vladc6@yahoo.com>
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
To: Rene Herman <rene.herman@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4637CB9F.9010408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <90482.84176.qm@web54407.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Rene Herman <rene.herman@gmail.com> wrote:
> On 05/02/2007 12:41 AM, Vlad wrote:
> 
> > H. Peter Anvin wrote:
> 
> >> I'm rewriting the i386 setup code in C, instead of assembly,
> >> and before I spend a very large amount of time translating
> >> all the various card-specific probes, I want to ask the
> >> following question...
> >>
> >> Does *anyone* care about these anymore?
> > 
> > Yes, booting Linux on old i386/i486 hardware is still very useful
> for
> > forensic purposes and recovering important data. I've personally
> had
> > to do this many times, and I'm sure others have as well.
> > 
> > Booting is such a critical process that a user would be completely
> > lost as to why it fails, especially if they can't see any output
> on
> > the screen. I think it would be a shame to prevent Linux from
> running
> > on these machines.
> 
> He wasn't asking about doing away with all video output on 386/486s,
> but 
> with special Super VGA adapter specific modes. You'd have normal VGA
> 
> available as always, and VESA if the videocard supports it (which
> all cards 
> that _can_ do more than 80x25 do).

Oh, OK. Thanks for clarifying this for me.

Vlad

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
