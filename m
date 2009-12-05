Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbZLEHGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbZLEHGG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 02:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbZLEHGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 02:06:05 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:60019 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbZLEHGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 02:06:05 -0500
X-Greylist: delayed 44413 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Dec 2009 02:06:05 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gGfBXETaEkaRtxANydm9orHj7zTAQ9JajxtKjkufBHsAPiU9zQUwtaybgukZ7P0FWR
         oRdb2roh0lNCAnyUM4XVnQDE2gv56fv3cn396T9yMT+TG1vSrv8HL8tEnWZe7SwpkhXg
         Y5XzTNrBsCTPY9wtZDSW1dsDfpNkMVJr+Wp+E=
MIME-Version: 1.0
In-Reply-To: <20091204234756.GA3517@ami.dom.local>
References: <20091125191105.GA3167@ami.dom.local>
	 <20091127213640.GA2611@ami.dom.local>
	 <81bfc67a0911271435g4106652bpe8c9ea07893d0ebd@mail.gmail.com>
	 <20091127224206.GA3350@ami.dom.local>
	 <81bfc67a0912031749y15faed66s9c8a924684c97a19@mail.gmail.com>
	 <20091204090524.GB6478@ff.dom.local>
	 <81bfc67a0912041028w16668d0cx4da04bee989eef4a@mail.gmail.com>
	 <20091204204443.GA2736@ami.dom.local>
	 <81bfc67a0912041507k6ef497f9w7b9294c90012e1a1@mail.gmail.com>
	 <20091204234756.GA3517@ami.dom.local>
Date: Sat, 5 Dec 2009 02:06:09 -0500
Message-ID: <81bfc67a0912042306v573d79acw7f0ef3d051a41724@mail.gmail.com>
Subject: Re: large packet loss take2 2.6.31.x
From: Caleb Cushing <xenoterracide@gmail.com>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Frans Pop <elendil@planet.nl>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       e1000-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I guess, you should better wait with new tests for some assistance
> from e1000e maintainers - it seems they might be interested in some
> specific dumps and registers - like in this #11998 case.

I reported here.

http://bugzilla.kernel.org/show_bug.cgi?id=14737
-- 
Caleb Cushing

http://xenoterracide.blogspot.com
