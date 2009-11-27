Return-Path: <linux-kernel-owner+w=401wt.eu-S1751662AbZK0SHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbZK0SHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 13:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751009AbZK0SHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 13:07:50 -0500
Received: from mail-gx0-f212.google.com ([209.85.217.212]:56073 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbZK0SHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 13:07:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FQrlALquqgBLklMs8ihwtM5FM8UBU5wFF1zN09jxwLZz2Lj9EoVt0NmH84a3W5XSWj
         PiatuHHymm2l/M/AZhnokLM9pyUZI3M49AJfegJKDxNfxL2t0db5RwpFeSADaXQ9xtZd
         8jwprvV/uN7vsDgiHMB+aMbubDPUcxZNbGsgk=
MIME-Version: 1.0
In-Reply-To: <20091125191105.GA3167@ami.dom.local>
References: <81bfc67a0911232217n41b9ac02w3b7770b789e5d209@mail.gmail.com>
	 <20091124111946.GA7883@ff.dom.local>
	 <81bfc67a0911250606k1ec76354n217da9ca20b3517c@mail.gmail.com>
	 <20091125191105.GA3167@ami.dom.local>
Date: Fri, 27 Nov 2009 13:07:53 -0500
Message-ID: <81bfc67a0911271007o1fb8f8c2vdd36e8585280e4da@mail.gmail.com>
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

2.6.32-rc8 seemed to be affected (guess. because my net didn't come up
on reboot. further testing will likely verify) also during reboots I
found out that the version I've been thinking is good is afflicted. I
supposed maybe I should try bisecting again? starting with that point.
not sure it'll do us much good if that version was able to slip by for
so long. I really hate intermittent bugs.


-- 
Caleb Cushing

http://xenoterracide.blogspot.com
