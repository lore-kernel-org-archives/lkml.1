Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbYCZOSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbYCZOSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 10:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbYCZOSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 10:18:37 -0400
Received: from lazybastard.de ([212.112.238.170]:51570 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbYCZOSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 10:18:36 -0400
Date: Wed, 26 Mar 2008 15:18:17 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, apw@shadowen.org, jirislaby@gmail.com,
       viro@ZenIV.linux.org.uk, joe@perches.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 109/148] include/asm-x86/serial.h: checkpatch cleanups - formatting only
Message-ID: <20080326141817.GG22847@logfs.org>
References: <20080326114142.GD22847@logfs.org> <20080326.044802.107678511.davem@davemloft.net> <20080326115853.GE22847@logfs.org> <20080326.050116.110367923.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080326.050116.110367923.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 March 2008 05:01:16 -0700, David Miller wrote:
> 
> > Sure, I buy that.  What I'm arguing here is why we have to be
> > consistently long instead of consistently short.  CodingStyle seems to
> > be silent on the question.
> 
> Becauseitmoreeasilyallowsyoureyestoseethedifferentoperators.

How many different operators are there in a cast? ;)

But you seem to be arguing the i=0 case.  Took me a while to notice
that.  Fair enough.

Jörn

-- 
Maintenance in other professions and of other articles is concerned with
the return of the item to its original state; in Software, maintenance
is concerned with moving an item away from its original state.
-- Les Belady
