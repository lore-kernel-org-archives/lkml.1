Return-Path: <linux-kernel-owner+w=401wt.eu-S1762369AbYCXPNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762369AbYCXPNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 11:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761033AbYCXPNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 11:13:30 -0400
Received: from lazybastard.de ([212.112.238.170]:44712 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760838AbYCXPNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 11:13:30 -0400
Date: Mon, 24 Mar 2008 16:12:59 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       viro@ZenIV.linux.org.uk, joe@perches.com, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: checkpatch [was: include/asm-x86/serial.h: checkpatch cleanups - formatting only]
Message-ID: <20080324151258.GE2899@logfs.org>
References: <47E647AC.1060906@gmail.com> <20080323.051929.267232495.davem@davemloft.net> <47E64BF7.4070808@gmail.com> <20080323.053037.144236584.davem@davemloft.net> <47E651BE.1080107@gmail.com> <877ift8hre.fsf@basil.nowhere.org> <47E7619C.6050402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47E7619C.6050402@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 March 2008 09:09:00 +0100, Jiri Slaby wrote:
> 
> Understand you points, but most of it is strict implementation of 
> CodingStyle. People, who don't prefer coding style as described in that 
> document, won't like checkpatch either.

I used to like CodingStyle.  Recently I've started to have doubts.
Basically, the file used to contain roughly this paraphrase:
"I know coding style is highly personly, but when possible I'd prefer to
 receive patches in this style..."

Over time the particular style has been refined more and more and the
tone of the document became a little more like:
"And the Lord sayeth, thou shalt not diverge from His style."

And that is just going too far.  Keeping the style roughly similar is
useful.  Several of the rules in CodingStyle are about writing code in a
way that avoids bugs.  Clearly useful.  But if you go too far you end in
religious zealotry.

Finding the right balance between following common rules and bending
them where appropriate is important - here as much as anywhere.

Jörn

-- 
The grand essentials of happiness are: something to do, something to
love, and something to hope for.
-- Allan K. Chalmers
