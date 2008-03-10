Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400AbYCJUKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbYCJUKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 16:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYCJUKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 16:10:09 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:33376 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbYCJUKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 16:10:08 -0400
To: Jan Kara <jack@suse.cz>
Cc: Peter Osterlund <petero2@telia.com>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com
Subject: Re: 2.6.24.2: 4KSTACKS + pcdrw + dm + mount -> stack overflow: ide-cd related? dm-related?
References: <87wsovkth5.fsf@hades.wkstn.nix> <87skzipcpw.fsf@hades.wkstn.nix>
	<m363wepa3a.fsf@telia.com> <87oda6p9st.fsf@hades.wkstn.nix>
	<20080306161459.GB3702@atrey.karlin.mff.cuni.cz>
From: Nix <nix@esperi.org.uk>
Emacs: more boundary conditions than the Middle East.
Date: Mon, 10 Mar 2008 20:09:18 +0000
In-Reply-To: <20080306161459.GB3702@atrey.karlin.mff.cuni.cz> (Jan Kara's message of "Thu, 6 Mar 2008 17:14:59 +0100")
Message-ID: <87iqzu5ok1.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-dcc.uncw.edu-Metrics: hades 1201; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Mar 2008, Jan Kara said:
>   If you are interested, linux-next or -mm tree should contain a patch now
> that fixes the problem...

As soon as I've figured out why dhclient is failing to establish DHCP
connections from 2.6.14.3 (the DHCPOFFERs seem to get ignored, it's
weird and the kernel shouldn't have anything to do with it, but it does)
so I can actually compile something that works and doesn't knock me off
the net every two minutes, I'll try it :)

(yes, I could try -mm directly, but it's been some weeks since I backed
up, thanks to an abruptly chocolate-filled CD-RW drive, so I'm being a
bit cautious.)

-- 
`The rest is a tale of post and counter-post.' --- Ian Rawlings
                                                   describes USENET
