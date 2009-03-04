Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbZCDPQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbZCDPQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 10:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbZCDPQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 10:16:23 -0500
Received: from mail.polezero.com ([216.68.55.34]:40668 "EHLO
	firewall.polezero.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751996AbZCDPQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 10:16:22 -0500
Subject: Re: New HID device support
From: Jason Noble <nobleja@polezero.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.0903041612210.4971@jikos.suse.cz>
References: <1236096277.26321.29.camel@paradox.pz.local>
	 <alpine.LNX.2.00.0903031720380.5295@jikos.suse.cz>
	 <1236107096.7793.1.camel@paradox.pz.local>
	 <alpine.LNX.2.00.0903041144310.4971@jikos.suse.cz>
	 <1236172544.21288.3.camel@paradox.pz.local>
	 <alpine.LNX.2.00.0903041419250.4971@jikos.suse.cz>
	 <1236173654.21288.8.camel@paradox.pz.local>
	 <alpine.LNX.2.00.0903041436210.4971@jikos.suse.cz>
	 <1236178031.9121.6.camel@paradox.pz.local>
	 <alpine.LNX.2.00.0903041612210.4971@jikos.suse.cz>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 10:16:10 -0500
Message-Id: <1236179770.9121.12.camel@paradox.pz.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No problem, glad to help out.
Very glad to get my buttons working. ;-)

Do you think this will make its way into 2.6.29?

On Wed, 2009-03-04 at 16:13 +0100, Jiri Kosina wrote:
> On Wed, 4 Mar 2009, Jason Noble wrote:
> 
> > I made a minor tweak. Please include in the official patch.
> > (BTN_2 and BTN_3, are not very useful xev doesn't even see them)
> > 
> > -       case 0x01: ks_map_key(BTN_2);   break;
> > -       case 0x02: ks_map_key(BTN_3);   break;
> > +       case 0x01: ks_map_key(BTN_MIDDLE);   break;
> > +       case 0x02: ks_map_key(BTN_SIDE);   break;
> > 
> > Other than that, it works great!
> > 
> > You are awesome, thank you very very much!!
> 
> Thanks for testing. I will put you in Reported-by:, if you don't mind, and 
> queue the patch patch in my tree.
> 

