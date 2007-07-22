Return-Path: <linux-kernel-owner+w=401wt.eu-S932646AbXGVXdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646AbXGVXdS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 19:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbXGVXdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 19:33:07 -0400
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:58049 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754698AbXGVXdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 19:33:06 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linus 2.6.23-rc1
Date: Mon, 23 Jul 2007 00:33:01 +0100
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Roland McGrath <roland@redhat.com>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707230033.01357.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 July 2007 22:04:24 Linus Torvalds wrote:
> So give it all a good whacking, and report back about all the neat new
> features!

I'm fairly sure this is already known about on SPARC64 (see David Miller's 
email ""build-id" changes break sparc64"), but I just thought I'd let people 
know the warnings are also visible on x86_64:

"ld: warning: Cannot create .note.gnu.build-id section, --build-id ignored."

gcc (GCC) 4.1.3 20070718 (prerelease) (Debian 4.1.2-14)
GNU assembler (GNU Binutils for Debian) 2.17.50.20070718

The kernel boots and works fine, however. The above tools are from Debian 
unstable.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.

