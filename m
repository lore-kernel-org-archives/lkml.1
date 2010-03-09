Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306Ab0CIRPP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:15:15 -0500
Received: from lo.gmane.org ([80.91.229.12]:39949 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab0CIRPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:15:11 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Florian Mickler <florian@mickler.org>
Subject: Re: Upstream first policy
Date: Tue, 9 Mar 2010 16:16:11 +0100
Message-ID: <20100309161611.1833523b@schatten.dmk.lab>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
	<20100308094647.GA14268@elte.hu>
	<20100308173008.7ae389ab@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
	<20100308190857.400bde09@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.1003081115280.3989@localhost.localdomain>
	<m1fx4apgch.fsf@fess.ebiederm.org>
	<7e0fb38c1003081518o7cddd121wa9c363a4e8211115@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: f053212233.adsl.alicedsl.de
In-Reply-To: <7e0fb38c1003081518o7cddd121wa9c363a4e8211115@mail.gmail.com>
X-Newsreader: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Mar 2010 18:18:21 -0500
Eric Paris <eparis@parisplace.org> wrote:


> You do realize that with content based security systems the pathnames
> aren't important and you could implement your example patch?  Sure a
> user could mount something on /lib and put their own files there, but
> since that user couldn't get them labelled correctly the suid app
> would not be able to use them and would fail.  Users would have new
> and interesting way to break their computers!  

but isn't that why a pathname based protect of /lib would be better? so
that users couldn't break their system? 

>I thank you for your
> vote for content based security systems instead of pathname systems
> and look forward to your future contributions to either that body of
> knowledge or the bridging of the gap between the two *smile*
> 
> -Eric

i interpret it not this way. but i'm an amateur securita :)

cheers,
Flo


