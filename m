Return-Path: <linux-kernel-owner+w=401wt.eu-S1423352AbXBPGkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423352AbXBPGkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 01:40:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423351AbXBPGkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 01:40:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:1674 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423350AbXBPGkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 01:40:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ePqZQ28EjkpwgzZ6yMk53QN1SRVbWDzY0w1yRwwchteC2lTMDfTGciF3s+nnSLOs0J/nG2Mf4bzVp/VL8/ZOrIUADDQuaRlJTO52yK6Ryjn+IOQq2efcKdgQL8hS+OdVDLbCallihOOMtO4xW6ipCyg40EpYZT2ykNVCuh4Iayg=
Message-ID: <653402b90702152240x5b242b65q5aaf347e2b6e2460@mail.gmail.com>
Date: Fri, 16 Feb 2007 07:40:02 +0100
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "v j" <vj.linux@gmail.com>
Subject: Re: GPL vs non-GPL device drivers
Cc: "Trent Waddington" <trent.waddington@gmail.com>,
       "David Lang" <david.lang@digitalinsight.com>,
       "Scott Preece" <sepreece@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <9b3a62ab0702152225m3893318by95cb8b260c74bfc2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
	 <9b3a62ab0702142227j19386132s870a0e745cfbb8d1@mail.gmail.com>
	 <20070215165339.GB5285@thunk.org>
	 <9b3a62ab0702151020k5bd0e4c9w763e1b01288ccc4f@mail.gmail.com>
	 <653402b90702151102n3a3e0435r837e2191de79b2b@mail.gmail.com>
	 <7b69d1470702151712x685f3e0eqf6198f9bb7f2394e@mail.gmail.com>
	 <Pine.LNX.4.63.0702151701510.10070@qynat.qvtvafvgr.pbz>
	 <9b3a62ab0702152148p57db8b1dgd42b1c6fb15dccbb@mail.gmail.com>
	 <3d57814d0702152157n461a9f0cta0a0c20e9a592d83@mail.gmail.com>
	 <9b3a62ab0702152225m3893318by95cb8b260c74bfc2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/07, v j <vj.linux@gmail.com> wrote:
> > It's written in black and white, in the license.
>
> Please point me to where it says I cannot load proprietary modules in
> the Kernel.
>
> >  Apart from that,
> > Greg KH has made his opinion clear, and you have said you understand
> > and don't debate that he holds this opinion, and his code is what you
> > said you were linking to (the sysfs/class stuff), so why do you keep
> > saying that "it is not clear".
>
> I know his opinion. I don't debate his opinion. It is his code. I
> choose not to use his code because of the license issue.
>
> > Do you think that, somehow, Linus' opinion trumps Greg KH's opinion on
> > his own code?
>
> No, just that the trend is disturbing. If enough Kernel Developers
> choose to write their Software in a way that prevents others from
> using it freely, then that is troubling. Especially when these Kernel

Isn't there a big difference between "use GPL code" and "modify GPL
code, link closed modules to it & redistribute everything as
binaries"?

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
