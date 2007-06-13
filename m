Return-Path: <linux-kernel-owner+w=401wt.eu-S1756260AbXFMUcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbXFMUcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 16:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953AbXFMUcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 16:32:35 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:59629
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbXFMUce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 16:32:34 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "debian developer" <debiandev@gmail.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Wed, 13 Jun 2007 16:32:30 -0400
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <466A3EC6.6030706@netone.net.tr> <20070610184736.464d1e32@the-village.bc.nu> <f24d23310706101232l335fbf1amff832c00339aa954@mail.gmail.com>
In-Reply-To: <f24d23310706101232l335fbf1amff832c00339aa954@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200706131632.31177.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 June 2007 15:32:42 debian developer wrote:
> On 6/10/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > licensing under the GPLv3, though. All I've heard are shrill voices
> > > about "tivoization" (which I expressly think is ok) and panicked
> > > worries about
> >
> > GPLv2 probably forbids Tivoisation anyway. Which is good IMHO even if not
>
>               ^^^^^^^^
>
> Now that is a bit waving in the air. GPLv2 forbids Tivoisation
> theoretically but practically it didnt stop them doing it practically.

A law never stops anybody from doing anything.  Enforcing the law does.

First of all, let's not confuse civil with criminal law:

http://nielsenhayden.com/makinglight/archives/009034.html
>  The difference between tort—breach of private rights—and crime—commission
> of an offence designated as such by the State—is one of the key legal
> concepts which the pro lawyer understands and the fan lawyer does not

Most variants of copyright infringement are a civil, not criminal matter.  
This means the state has no interest in enforcing the, it's your job to sue 
for damages and a restraining order if you want to exercise these rights 
(some people choose not to), and you have to have standing (I.E. be a holder 
of one of the infringed copyrights, or a designated legal representative 
thereof) in order to sue.  If none of the copyright holders sue to stop it, 
then it doesn't get stopped no matter how blatantly infringing it is.  Did 
anybody even bother to send Tivo a cease and desist?

Erik Andersen burned himself out trying to enforce the copyrights on BusyBox 
before Pamela Jones hooked that project (and uClibc) up with the SFLC.  
Harald Welte's been burning the candle at both ends with gpl-violations.org, 
but he's focusing on stuff sold in Germany.

As for anti-tivoisation, you can make a case that your signed binary is a 
derived work of the GPL source code just like a non-signed binary is, 
therefore the signing key is part of the source code used to create that 
binary, therefore GPLv2 requires the signing key be handed over on request.  
(I don't know if you'd WIN, I just know you could reasonably argue it in 
court and probably get past the inevitable initial motions to dismiss.)

GPLv2 is a nice, elegant license.  It's not perfect but it's very simple for 
what it does.

GPLv3 is not simple, not elegant, and contains numerous of special cases.  
Lots of the programmers here have an instinctive aversion to it because it 
reads like bad code.  We don't necessarily have to program in legalese to 
sense bad code in that language, at least compared to a "good code" example 
we've been using for some time.

Rob
