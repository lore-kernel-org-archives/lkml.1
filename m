Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbXHTTyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbXHTTyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 15:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbXHTTyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 15:54:06 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:34240 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbXHTTyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 15:54:04 -0400
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Marc Perkel <mperkel@yahoo.com>, Brennan Ashton <comphappy@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>, Kyle Moffett <mrmacman_g4@mac.com>,
       Phillip Susi <psusi@cfl.rr.com>,
       Michael Tharp <gxti@partiallystapled.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: Thinking outside the box on file systems
References: <465458.84259.qm@web52505.mail.re2.yahoo.com>
	<46C9B2A9.1010904@aitel.hist.no>
From: Nix <nix@esperi.org.uk>
Emacs: the prosecution rests its case.
Date: Mon, 20 Aug 2007 20:52:45 +0100
In-Reply-To: <46C9B2A9.1010904@aitel.hist.no> (Helge Hafting's message of "Mon, 20 Aug 2007 17:26:33 +0200")
Message-ID: <87tzqum19u.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-CTc-dcc2-Metrics: hades 1031; Body=9 Fuz1=9 Fuz2=9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 Aug 2007, Helge Hafting stated:
> Shooting down bad ideas saves tremendous amounts of work,
> killing an idea at the discussion stage means the idea never
> got to the much more labor-intensive implementation stage.
>
> This don't mean that all new ideas are killed, only the bad ones.

Even the good ones pretty much never start out perfect[1]. It always
takes some criticism and fixing before the code is right, let alone
the design.

(Of course part of the problem with this idea is that it was so vague
that the only problems there *could* be with it were huge gaping ones:
you can't have subtle problems with an idea with no subtle elements.
Unfortunately it had a lot of those, and fixing them without junking
the whole idea would be hard. No, I haven't thought about how to do
it: Marc might like to, though, what with it being his idea and all.)

[1] except mingo's. mingo has the Perfect Design Mojo. How this came
    to pass, mere mortals may not speculate.
