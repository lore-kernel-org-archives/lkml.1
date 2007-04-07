Return-Path: <linux-kernel-owner+w=401wt.eu-S965953AbXDGPH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965953AbXDGPH5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 11:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966015AbXDGPH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 11:07:57 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:50568 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965748AbXDGPHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 11:07:55 -0400
Message-Id: <1175958475.27071.1183468234@webmail.messagingengine.com>
X-Sasl-Enc: VErYKh74FNCtcV9Pe0rRT45O5qd+qkrWxS+XkONoD32+ 1175958475
From: johnrobertbanks@fastmail.fm
To: "Krzysztof Halasa" <khc@pm.waw.pl>
Cc: "Jan Harkes" <jaharkes@cs.cmu.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <46157B5B.5000602@gmail.com>
   <1175817921.18400.1183285196@webmail.messagingengine.com>
   <461592FB.5060507@zytor.com>
   <1175819681.20754.1183287946@webmail.messagingengine.com>
   <461596DE.2020802@zytor.com>
   <1175823288.25662.1183293506@webmail.messagingengine.com>
   <4615C780.5040407@zytor.com>
   <1175833931.8916.1183307802@webmail.messagingengine.com>
   <20070406152119.GC4228@delft.aura.cs.cmu.edu>
   <1175914056.9653.1183426876@webmail.messagingengine.com>
   <20070407033049.GI4228@delft.aura.cs.cmu.edu>
   <1175925525.21154.1183436614@webmail.messagingengine.com>
   <m34pns46l9.fsf@maximus.localdomain>
Subject: Re: Reiser4. BEST FILESYSTEM EVER.
In-Reply-To: <m34pns46l9.fsf@maximus.localdomain>
Date: Sat, 07 Apr 2007 08:07:55 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Krzysztof -- Aren't you missing the point? Twice the speed would be
great,... even a 50% increase,... even a 0% increase.

I checked what bonnie++ actually writes to its test files, for you. It
is about 98-99% zeros.

Still, the results record sequential reads, of 232,729 K/sec, nearly
four times the physical disk read rate, 63,160 K/sec, of the hard drive.

The sequential writes are about three times the physical disk write
rate.

Even if the speed increase was zero, the more efficient use of disk
space means that Reiser4 is worth investigating.

People use RAID arrays to achieve speed increases. 

The people who developed RAID clearly thought that increases in speed
were worth investigating.

> 
> > Why do you think I hate reiserfs developers? That is an insane claim.
> > Why would I hate reiser3 developers?
> > Why would I hate reiser4 developers? 
> > Why would I even dislike them?
> >
> > I think Hans Reiser is a genius. Is that what you mean by hate?
> 
> I think they could hire a person with a bit better marketing skills,
> though. People on a technical mailing list don't buy things just
> because something on TV told them they have to.

I don't work for Reiser if that is what you are suggesting.

And people buy all sorts of lies because someone on TV told them it was
true.

Did you believe Iraq had WMD (weapons of mass destruction) because a
bunch of American liars told you this on TV? Millions of Americans did.

> > Answer this question. Why do YOU think I am antagonizing reiserfs
> > developers?
> 
> That might be just a side effect.
> 
-- 
  
  johnrobertbanks@fastmail.fm

-- 
http://www.fastmail.fm - Send your email first class

