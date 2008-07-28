Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbYG1Qm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbYG1Qm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 12:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbYG1Qmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 12:42:46 -0400
Received: from sirius.lasnet.de ([78.47.116.19]:50073 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbYG1Qmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 12:42:46 -0400
Date: Mon, 28 Jul 2008 18:42:51 +0200
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: David Sterba <dsterba@suse.cz>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, jkosina@suse.cz
Message-ID: <20080728164251.GB4397@dodger.lab.datenfreihafen.org>
References: <20080728145124.13378.39300.stgit@ds.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080728145124.13378.39300.stgit@ds.suse.cz>
X-Mailer: Mutt http://www.mutt.org/
X-KeyID: 0xDDF51665
X-Website: http://www.datenfreihafen.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
Subject: Re: [RESEND][PATCH 00/12] ipwireless: driver updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Mon, 2008-07-28 at 16:52, David Sterba wrote:
> 
> series contains code cleanups and a few improvements.

It's now in Linus Tree and I get this:

CC [M]  drivers/char/pcmcia/ipwireless/hardware.o
drivers/char/pcmcia/ipwireless/hardware.c: In function ‘pool_allocate’:
drivers/char/pcmcia/ipwireless/hardware.c:571: error: invalid use of undefined type ‘struct ipw_network’
make[4]: *** [drivers/char/pcmcia/ipwireless/hardware.o] Error 1

regards
Stefan Schmidt
