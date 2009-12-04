Return-Path: <linux-kernel-owner+w=401wt.eu-S932329AbZLDXHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbZLDXHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 18:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757509AbZLDXHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 18:07:37 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:64153 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757451AbZLDXHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 18:07:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EeVabq0oB314v8oFV3LmjMapShhCgMmmQoGIUBIKd0QDrKK+cWqLaAr4x7VmmgwPlB
         FO6d1dMZXMC27v9tJk0+5vDENYita0R/C7xrsmUkFMiyFrHD+4b7K/ywzUubHidw3FjL
         AG6W7OHC5sXYn43rOa2moxAxsu/iSOdwcsPog=
MIME-Version: 1.0
In-Reply-To: <20091204204443.GA2736@ami.dom.local>
References: <20091124111946.GA7883@ff.dom.local>
	 <20091125191105.GA3167@ami.dom.local>
	 <81bfc67a0911271007o1fb8f8c2vdd36e8585280e4da@mail.gmail.com>
	 <20091127213640.GA2611@ami.dom.local>
	 <81bfc67a0911271435g4106652bpe8c9ea07893d0ebd@mail.gmail.com>
	 <20091127224206.GA3350@ami.dom.local>
	 <81bfc67a0912031749y15faed66s9c8a924684c97a19@mail.gmail.com>
	 <20091204090524.GB6478@ff.dom.local>
	 <81bfc67a0912041028w16668d0cx4da04bee989eef4a@mail.gmail.com>
	 <20091204204443.GA2736@ami.dom.local>
Date: Fri, 4 Dec 2009 18:07:42 -0500
Message-ID: <81bfc67a0912041507k6ef497f9w7b9294c90012e1a1@mail.gmail.com>
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

> So, again, if you're willing to debug this, the new bugzilla report
> seems reasonable to me, plus maybe some notice to this #11998 too.

I will later today. I'm thinking since I now have 2 active nics...
would hooking the 1 card directly to the other and then running the
tests be helpful? (I wish this mobo had a 3rd pci slot because I'd
have put a 3rd card in so I can connect to the net at the same time.


-- 
Caleb Cushing

http://xenoterracide.blogspot.com
