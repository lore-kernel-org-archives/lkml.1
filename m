Return-Path: <linux-kernel-owner+w=401wt.eu-S966196AbXILKUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966196AbXILKUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 06:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763356AbXILKUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 06:20:37 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:29581 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762404AbXILKUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 06:20:37 -0400
Date: Wed, 12 Sep 2007 12:20:32 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Michael Neuling <mikey@neuling.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       paulus@samba.org, Alan Cox <alan@redhat.com>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] powerpc: add new required termio functions
Message-ID: <20070912102032.GB7858@osiris.boeblingen.de.ibm.com>
References: <8018.1189562679@neuling.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8018.1189562679@neuling.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 12:04:39PM +1000, Michael Neuling wrote:
> The "tty: termios locking functions break with new termios type" patch
> (f629307c857c030d5a3dd777fee37c8bb395e171) breaks the powerpc compile.
> [...]
> I'm guessing other architectures are broken too?

FWIW, the above quoted patch breaks s390 as well.
