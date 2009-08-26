Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbZHZBGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbZHZBGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 21:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932778AbZHZBGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 21:06:21 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:33797 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932564AbZHZBGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 21:06:21 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Aug 2009 21:06:20 EDT
Message-ID: <4A9488FB.60603@eukrea.com>
Date: Wed, 26 Aug 2009 02:59:39 +0200
From: =?ISO-8859-1?Q?Eric_B=E9nard?= <eric@eukrea.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Robert Emanuele <rob@emanuele.us>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: ARM Git Tree (at91sam9g45 patches)
References: <9f53b4330908251727q1bc1accfk12a9a8d25407791@mail.gmail.com>
In-Reply-To: <9f53b4330908251727q1bc1accfk12a9a8d25407791@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 9914956054954618310
X-Ovh-Remote: 82.228.175.43 (tal33-2-82-228-175-43.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

Robert Emanuele wrote :
> I'm working with the Atmel at91sam9g45-ekes board which is new.  I was
> wondering if there was a git tree with the current ARM patches that
> contains the at91sam9g45 code?  Russell lists "Applied" patches at
> http://www.arm.linux.org.uk/developer/patches/ .  Where are these
> applied to?  If there isn't a tree, is there an elegant way to get the
> latest patch sets that I could apply to Linus's tree?
> 
you will find the files that you can apply using git am here :
ftp://ftp.arm.linux.org.uk/pub/armlinux/kernel/git-cur/

Eric
