Return-Path: <linux-kernel-owner+w=401wt.eu-S1759955AbZDGCOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955AbZDGCOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 22:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbZDGCOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 22:14:31 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:52207 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbZDGCOa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 22:14:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=yCOLJ/DDw9Ejsetf6IU8Gtu27FEM7aZLilb37DpTAd14D5L51lJRLyoH1FGH4iW/kh
         VIJG96o+dtGUs7WEYzxg3sLy7WDN/7siW+C/60kxZUE5rQPc/vpnU4550CINPFTnPw8R
         9s4ufHXTMnMeOVWER9ncP9qd/nulcBHmo1PbI=
MIME-Version: 1.0
In-Reply-To: <9b1675090904061913o614e02fdl22ef2cf795525a6d@mail.gmail.com>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
	 <AsKNxFx2juN.A.0OH.0Fn2JB@chimera>
	 <9b1675090904061913o614e02fdl22ef2cf795525a6d@mail.gmail.com>
Date: Mon, 6 Apr 2009 20:14:28 -0600
Message-ID: <9b1675090904061914m4d5e204lbf726a07ba406cf2@mail.gmail.com>
Subject: Re: [Bug #13018] 2.6.29 on MacBook 2,1 fails to reboot
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alistair John Strachan <alistair@devzero.co.uk>,
       mstevens@win-professional.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 6, 2009 at 8:13 PM, Trenton D. Adams
<trenton.d.adams@gmail.com> wrote:
> Hi Rafael,
>
> Yes, it is still a problem.  I have identified it as far down to being
> an alsa problem.  Please follow the other thread related to this.  I

Oops, sorry, I should make clear that it is not an alsa problem
specifically, but an alsa hda-intel driver issue, which is related to
alsa.
