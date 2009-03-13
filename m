Return-Path: <linux-kernel-owner+w=401wt.eu-S1759351AbZCMUpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbZCMUpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 16:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbZCMUpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 16:45:35 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53700 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbZCMUpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 16:45:35 -0400
Date: Fri, 13 Mar 2009 16:41:01 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Nico Schottelius <nico-linux-20090313@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net
Subject: Re: Strange reboots on 2.6.29-rc6-wl
Message-ID: <20090313204100.GA3554@tuxdriver.com>
References: <20090313200657.GA4907@denkbrett.schottelius.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313200657.GA4907@denkbrett.schottelius.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 09:06:57PM +0100, Nico Schottelius wrote:
> Hello!
> 
> I've two Lenovo X200 here, same config and same kernel version
> (2.6.29-rc7-wl-ikn, from wireless-testing, v2.6.29-rc7-17155-g2f7ab92).
> 
> One reboots after half a second after displaying a message Probing for edd
> (or similar). I tried with and without edd=off, no changes.
> 
> The same happens with v2.6.29-rc7-32930-g5434dd7 (iwlwifi-2.6).
> 
> Anyone an idea, what maybe the reason for that behaviour?

No clue.  But since you clearly are comfortable with git and building
your own kernels, perhaps you can use git bisect to suggest which
commit is broken? :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
