Return-Path: <linux-kernel-owner+w=401wt.eu-S1762016AbXGEUhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762016AbXGEUhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 16:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759269AbXGEUhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 16:37:05 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:49602 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759187AbXGEUhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 16:37:03 -0400
To: 7eggert@gmx.de
Cc: Karel Zak <kzak@redhat.com>,
       List util-linux-ng <util-linux-ng@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
References: <8CYT9-4Ou-23@gated-at.bofh.it> <8Dh9k-8lT-3@gated-at.bofh.it>
	<8DtDz-3xC-15@gated-at.bofh.it> <E1I6SfW-0002XG-AM@be1.lrz>
From: Nix <nix@esperi.org.uk>
Emacs: well, why *shouldn't* you pay property taxes on your editor?
Date: Thu, 05 Jul 2007 21:36:52 +0100
In-Reply-To: <E1I6SfW-0002XG-AM@be1.lrz> (Bodo Eggert's message of "Thu, 05 Jul 2007 16:50:54 +0200")
Message-ID: <87zm2aegez.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.5-b27 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-dcc1-Metrics: hades 1182; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 Jul 2007, Bodo Eggert outgrape:
> I'm really really happy if I read 'edit Makefile.conf and run make...'.

autobuild scripts find it a hell of a lot more annoying to edit a different
makefile for every project than to run one unchanging config.site...

It's hardly a killer, but it would be a step backwards IMO :( by all
means switch to a nicer build system: cmake, perhaps? but ditching
standardized build systems entirely is not so good.

-- 
`... in the sense that dragons logically follow evolution so they would
 be able to wield metal.' --- Kenneth Eng's colourless green ideas sleep
 furiously
