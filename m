Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbZK0Wfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbZK0Wfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 17:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbZK0Wf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 17:35:29 -0500
Received: from mail-gx0-f212.google.com ([209.85.217.212]:34715 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbZK0Wf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 17:35:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XsbzmX2tMesTHKaSPCeDjqAw+m2wi4xDOcjNmyVAeWoYr7TQIufK3EziRXYDfJ7ET6
         fTEV9y2PMmpjQECUD2zcutla9zkHx0ExQDrgispXSjclHdHHZ/G/RvrsPfgn9iGDGFfj
         pZo6eYyhOJ5apbeJJvDvFXzpxelCtbA4BACIo=
MIME-Version: 1.0
In-Reply-To: <20091127213640.GA2611@ami.dom.local>
References: <81bfc67a0911232217n41b9ac02w3b7770b789e5d209@mail.gmail.com>
	 <20091124111946.GA7883@ff.dom.local>
	 <81bfc67a0911250606k1ec76354n217da9ca20b3517c@mail.gmail.com>
	 <20091125191105.GA3167@ami.dom.local>
	 <81bfc67a0911271007o1fb8f8c2vdd36e8585280e4da@mail.gmail.com>
	 <20091127213640.GA2611@ami.dom.local>
Date: Fri, 27 Nov 2009 17:35:34 -0500
Message-ID: <81bfc67a0911271435g4106652bpe8c9ea07893d0ebd@mail.gmail.com>
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

> I doubt bisecting is a good idea with so unpredictable bug. First, you
> should make sure it's not a hardware problem, so go back to the kernel
> you trust most, and give it a really long try with a few recompilations
> after slightly changing the config. Btw, I wonder if you tried e1000e
> module parameters like IntMode=0 or 1.

no, how do I set those?


-- 
Caleb Cushing

http://xenoterracide.blogspot.com
