Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbYIYENd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbYIYENd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 00:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYIYENX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 00:13:23 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:44793 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750834AbYIYENW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 00:13:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NdUWU6I7GUJrg4F4x6LamD1+hgVlCy2L3WXAL75wvYhLPp4kI8VNw7gdbDAVKWfh1YdAd1uygG+xwSxcBM5O1GyugrNYLRFp+eejzhvuvxAzO3IMP+z0n2Ceul9lXpAxZijHvvLh65DOWm1AYJmTs90t0I3W7q2O/4qDm/lIFLE=  ;
X-YMail-OSG: iBy_beUVM1m4utLYTTllFjZLzebU8UrdgcWR4Pj5r6muKMCud160twQCQSk1QSJjgzFyvSZ2v.jDWzQ10t1XWf50k5jD4hBp1aT.ta9YtWo8AOg5YXHsukOJzdDuZJh25uzzS5W9gpSUxYlxjnK0oF0.8fdO
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH 2/4] powerpc/qe: new call to revert a gpio to a dedicated function
Date: Wed, 24 Sep 2008 21:13:18 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>, linuxppc-dev@ozlabs.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080924000255.GA28054@oksana.dev.rtsoft.ru> <200809241154.25722.david-b@pacbell.net> <20080924232956.GA27533@oksana.dev.rtsoft.ru>
In-Reply-To: <20080924232956.GA27533@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809242113.18992.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 September 2008, Anton Vorontsov wrote:
> 
> Anyway, just want to thank you for your time and persistence on this
> matter, you're forcing others' people brains to *work*.  And since you 
> rejected this approach too, I have no other option but to implement
> something else... something better. ;-)

I think you have enough pieces in place to get that
"something better" _very_ quickly.  Or I'd feel worse
about abusing those poor little grey cells.  ;)
