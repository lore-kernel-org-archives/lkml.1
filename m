Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbZLAK26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbZLAK26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 05:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbZLAK26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 05:28:58 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52154 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbZLAK25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 05:28:57 -0500
Date: Tue, 1 Dec 2009 10:29:01 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 1
Message-ID: <20091201102900.GA11715@sirena.org.uk>
References: <20091201190301.0fb7abad.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091201190301.0fb7abad.sfr@canb.auug.org.au>
X-Cookie: I know how to do SPECIAL EFFECTS!!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 01, 2009 at 07:03:01PM +1100, Stephen Rothwell wrote:

> Merging sound/for-next
> Applying: ASoC: tlv320dac33: Change RT wq to singlethread wq

According to this the sound tree should be being merged into the next
tree but when I look in the master branch of your git I'm not seeing any
sign of it - am I missing something here?  The head of your master
branch that I see is 16aa56906ae11bfdb145676a5fb5c5f43394148d "Add
linux-next specific files for 20091201".

The same thing happened yesterday.
