Return-Path: <linux-kernel-owner+w=401wt.eu-S1764270AbXHGFFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764270AbXHGFFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 01:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbXHGFFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 01:05:10 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:9423 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbXHGFFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 01:05:08 -0400
X-Greylist: delayed 158801 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Aug 2007 01:05:08 EDT
From: Axel Reinhold <axel@freakout.de>
Message-Id: <200708070504.l7754KIr004277@bongo.freakout.de>
Subject: Re: Kernel Bug in 2.4.35 when compiled gcc>=4.2.0 and
 -march=c3
In-Reply-To: <20070806211631.GA14501@1wt.eu>
To: Willy Tarreau <w@1wt.eu>
Date: Tue, 7 Aug 2007 07:04:20 +0200 (CEST)
CC: Segher Boessenkool <segher@kernel.crashing.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Axel Reinhold <axel@freakout.de>,
       linux-kernel@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL123f (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="US-ASCII"
X-Logged: Logged by bongo.freakout.de as l7754KIr004277 at Tue Aug  7 07:04:20 2007
X-RZG-AUTH: lUESeo99iNzPSoEmsz8hSOHHL4mD896CIlAzdW8M7hBAattaCEuwS8jKioY=
X-RZG-CLASS-ID: mo00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

According to Willy Tarreau:
> > >Well, top-level assembly is usually nasty.  Setting the section in the
> > >assembly statement as you said is probably the only thing you *can* do.
> > 

I do not understand the details of the discussion, but isn't the
fact, that there is more than one way for the compiler to produce
"correct" code of the nasty statements, also a "timebomb" for
other projects - especially for Linux 2.6?

Axel
