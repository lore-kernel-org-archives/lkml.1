Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbYJMWEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbYJMWEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 18:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbYJMWEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 18:04:08 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:47216 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594AbYJMWEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 18:04:07 -0400
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Peter Osterlund <petero2@telia.com>,
       a.zummo@towertech.it
Subject: Re: pktcdvd -> sysfs warning with 2.6.27
References: <87vdvyngni.fsf@hades.wkstn.nix>
	<20081012181700.GA21072@kroah.com> <87prm4mbgy.fsf@hades.wkstn.nix>
	<20081013214747.GA15765@kroah.com>
From: Nix <nix@esperi.org.uk>
Emacs: resistance is futile; you will be assimilated and byte-compiled.
Date: Mon, 13 Oct 2008 23:03:55 +0100
In-Reply-To: <20081013214747.GA15765@kroah.com> (Greg KH's message of "Mon, 13 Oct 2008 14:47:47 -0700")
Message-ID: <87d4i4m9tg.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-dcc1-Metrics: hades 1182; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 Oct 2008, Greg KH verbalised:
> On Mon, Oct 13, 2008 at 10:28:13PM +0100, Nix wrote:
>> They could do with proper device numbers. No matter what this is going
>> to break some non-udev setups :(
>
> It's going to break all setups, no matter if udev is involved here or
> not...

I meant the *renumbering* would break static /dev. Obviously the
duplication is going to break things :)

-- 
`Not even vi uses vi key bindings for its command line.' --- PdS
