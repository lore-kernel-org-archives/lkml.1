Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbZKDBJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbZKDBJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 20:09:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbZKDBJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 20:09:54 -0500
Received: from icculus.org ([67.106.77.212]:33577 "EHLO icculus.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbZKDBJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 20:09:53 -0500
Date: Tue, 3 Nov 2009 20:09:53 -0500 (EST)
From: "Ryan C. Gordon" <icculus@icculus.org>
X-X-Sender: icculus@caridad.icculuslan
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: =?ISO-8859-15?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: FatELF patches...
In-Reply-To: <alpine.OSX.1.10.0911021509090.702@caridad.icculuslan>
Message-ID: <alpine.OSX.1.10.0911032006320.11070@caridad.icculuslan>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com> <alpine.OSX.1.10.0911011540400.53392@caridad.local> <20091102000147.424f104b@lxorguk.ukuu.org.uk>
 <alpine.OSX.1.10.0911021057450.464@caridad.icculuslan> <20091102185315.6326e148@lxorguk.ukuu.org.uk> <alpine.OSX.1.10.0911021509090.702@caridad.icculuslan>
User-Agent: Alpine 1.10 (OSX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> You mentioned the patent thing and I don't have an answer at all yet from 
> a lawyer. Let's table this for awhile until I have more information about 
> that. If there's going to be a patent problem, it's not worth wasting 
> everyone's time any further.
> 
> If it turns out to be no big deal, we can decide to revisit this.

The Software Freedom Law Center replied with this...

"I refer you to our Legal Guide section on dealing with patents available 
from our website.  I also refer you to our amici brief in Bilski, where we 
argue that patents on pure software are invalid.  If a patent is invalid, 
there's no reason to consider whether it is infringed."

...which may be promising some day, but doesn't resolve current concerns. 
Also: "I read a FAQ" doesn't hold up in court.  :)

Based on feedback from this list, the patent concern that I'm not 
qualified to resolve myself, and belief that I'll be on the losing end of 
the same argument with the glibc maintainers after this, I'm withdrawing 
my FatELF patch. If anyone wants it, I'll leave the project page and 
patches in place at http://icculus.org/fatelf/ ...

Thank you everyone for your time and feedback.

--ryan.

