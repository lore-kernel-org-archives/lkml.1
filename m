Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbZFYHMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbZFYHMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 03:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbZFYHM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 03:12:26 -0400
Received: from fed1rmmtao104.cox.net ([68.230.241.42]:64064 "EHLO
	fed1rmmtao104.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbZFYHM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 03:12:26 -0400
X-VR-Score: -110.00
X-Authority-Analysis: v=1.0 c=1 a=f-GefS3wO1IA:10 a=EKeX-pp0AAAA:8
 a=ZSFQUDYELv5ILXZVOwMA:9 a=pP1wWgDYPhkw0fdYL_NMEqFYwgIA:4 a=R-wd4IrMln8A:10
X-CM-Score: 0.00
To: "John Stoffel" <john@stoffel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Blackfin Architecture Team 
	<uclinux-dist-devel@blackfin.uclinux.org>,
       David Howells <dhowells@redhat.com>, stable@kernel.org
Subject: Re: Fix for shared flat binary format in 2.6.30
References: <4A3F5EAE.7020402@t-online.de>
	<alpine.LFD.2.01.0906221137580.3240@localhost.localdomain>
	<19007.60396.259650.682653@stoffel.org>
From: Junio C Hamano <gitster@pobox.com>
Date: Thu, 25 Jun 2009 00:12:28 -0700
In-Reply-To: <19007.60396.259650.682653@stoffel.org> (John Stoffel's message of "Mon\, 22 Jun 2009 16\:39\:08 -0400")
Message-ID: <7vab3wiy77.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"John Stoffel" <john@stoffel.org> writes:

>> git commit -a
>
> # Put in a simple message of a line or two.
>
>     ratelimit parity error reporting, which helps alot on bootup over serial
>     console when you get 10,000+ lines of this message.

Doesn't this violate the accepted standard format for commit messages in
the linux kernel project?

Perhaps Documentation/SubmittingPatches #2 and #15 need to be read, or
clarified, or both.



