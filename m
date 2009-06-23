Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbZFWUqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbZFWUqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 16:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbZFWUp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 16:45:57 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:49996 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbZFWUp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 16:45:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Oqh/8fJZgHzTwzbHMU29tq4PHOHDX+R0OdH5v56LMeltSz/nEw00E1Gov3l+91MhR3
         01LDbzISVWp6ydXCFH5hPXkyfb5kvRx3TauhU4Wj96mM3jBbvV4Y+kufzQXixYfVgsO3
         cejMrlcPf8BkHtLX4ChtvFCUbjD2XArN/txes=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0906231210040.3240@localhost.localdomain>
References: <20090622222217.GH23972@bombadil.infradead.org> 
	<m3fxdqj2bz.fsf@lwn.net> <m3bpoen5pp.fsf@intrepid.localdomain> 
	<20090623130602.6cd6b713@chukar> <alpine.LFD.2.01.0906231210040.3240@localhost.localdomain>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 23 Jun 2009 13:45:29 -0700
X-Google-Sender-Auth: 79b50cfffab91599
Message-ID: <43e72e890906231345p459e6080q2d606dc6bbd09fa@mail.gmail.com>
Subject: Re: [PATCH v3.1415] Documentation: add documentation summary for 
	rc-series and merge window
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jake Edge <jake@lwn.net>, Krzysztof Halasa <khc@pm.waw.pl>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       "corbet@lwn.net" <corbet@lwn.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "tshibata@ab.jp.nec.com" <tshibata@ab.jp.nec.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 12:11 PM, Linus
Torvalds<torvalds@linux-foundation.org> wrote:

> In fact, this whole discussion has shown one thing: people still think
> that "bug fix" somehow automatically means that it's appropriate after the
> merge window. That's simply not so.

And that really was the goal of this documentation extension patch, to
clarify that fact. I'm sure Jonathan can do a better job than what I
am trying though, with the added benefit he won't create words out of
thin air :)

  Luis
