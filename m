Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbYJLWg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbYJLWg7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 18:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbYJLWgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 18:36:51 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:37167 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbYJLWgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 18:36:50 -0400
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Peter Osterlund <petero2@telia.com>
Subject: Re: pktcdvd -> sysfs warning with 2.6.27
References: <87vdvyngni.fsf@hades.wkstn.nix>
	<20081012181700.GA21072@kroah.com> <87iqrxo924.fsf@hades.wkstn.nix>
	<20081012221851.GB22940@kroah.com>
From: Nix <nix@esperi.org.uk>
Emacs: anything free is worth what you paid for it.
Date: Sun, 12 Oct 2008 23:36:43 +0100
In-Reply-To: <20081012221851.GB22940@kroah.com> (Greg KH's message of "Sun, 12 Oct 2008 15:18:51 -0700")
Message-ID: <87d4i5o2ys.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-CTc-dcc2-Metrics: hades 1031; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 Oct 2008, Greg KH verbalised:

> On Sun, Oct 12, 2008 at 09:25:07PM +0100, Nix wrote:
>> On 12 Oct 2008, Greg KH stated:
>> > Perhaps some other kernel code is registering with that same major/minor
>> > number, making it already present in sysfs.  Where does that sysfs file
>> > link to before you load your driver?
>> 
>> It's not modular right now so it's sort of hard to tell. I'll rebuild it
>> as a module and have a look (be a while before I can reboot though,
>> other people are using this machine right now).
>
> How about before you run that command on the machine?

Oh, er, true, that would work too.

Still needs a reboot though :/

-- 
`Not even vi uses vi key bindings for its command line.' --- PdS
