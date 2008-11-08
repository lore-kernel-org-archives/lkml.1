Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbYKHLCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbYKHLCg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 06:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYKHLC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 06:02:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:50463 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbYKHLC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 06:02:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fBnJKJfJ+Uk4JQ4/C5Lq9c1tvHgbdEx8saDjnc1XLQmDQMeNb+7LuYJ/fenh4f0IGh
         lj1t8FAK5Q5XRsnR7wJuEXVSqPP4V8DU8UvhNC8CbF3A/hpsiH3MBH1LvSb3tXy9ecWD
         wqKpNZzCw13f74I1ZMDfhE+xIyWJ5JsHAgT2Q=
Message-ID: <d9def9db0811080302r35823330k167042d2e8462340@mail.gmail.com>
Date: Sat, 8 Nov 2008 12:02:25 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: [PATCH 1/7] Adding empia base driver
Cc: "Andre Kelmanson" <akelmanson@gmail.com>,
       "Hans Verkuil" <hverkuil@xs4all.nl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>, acano@fastmail.fm,
       "Bouwsma Barry" <freebeer.bouwsma@gmail.com>,
       "Dan Kreiser" <kreiser@informatik.hu-berlin.de>,
       "Frank Neuber" <fn@kernelport.de>,
       "Jelle de Jong" <jelledejong@powercraft.nl>,
       "John Stowers" <john.stowers.lists@gmail.com>,
       "Lukas Kuna" <lukas.kuna@evkanet.net>,
       "Stefan Vonolfen" <stefan.vonolfen@gmail.com>,
       "Stephan Berberig" <s.berberig@arcor.de>,
       "Thomas Giesecke" <thomas.giesecke@ibgmbh-naumburg.de>,
       "Vitaly Wool" <vwool@ru.mvista.com>, "Zhenyu Wang" <zhen78@gmail.com>,
       v4l <video4linux-list@redhat.com>, linux-dvb@linuxtv.org,
       greg@kroah.com, "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0811080549191.7489@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com>
	 <200811011459.17706.hverkuil@xs4all.nl>
	 <20081102022728.68e5e564@pedra.chehab.org>
	 <a2aa6e3a0811072150t535e802cge3375a7b88ee6287@mail.gmail.com>
	 <20081108081508.496f6582@pedra.chehab.org>
	 <d9def9db0811080222l57e9db9fwb835395d6069571@mail.gmail.com>
	 <alpine.LFD.2.00.0811080529000.7489@bombadil.infradead.org>
	 <d9def9db0811080242v5fd108c6g80873f681e17224a@mail.gmail.com>
	 <alpine.LFD.2.00.0811080549191.7489@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 8, 2008 at 11:56 AM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> On Sat, 8 Nov 2008, Markus Rechberger wrote:
>
>> Should I start picking patches from the linuxtv.org tree where patches
>> from my tree are taken
>> and where the Sign off is not provided?
>
> SOB's are just meant to testify that the code is GPL. It has nothing to do
> with authorship.
>
> On all cases I'm aware, when some code from your tree were merged upstream,
> your authorship were marked inside the patch's description. Also, your
> authorship are explicit at the em28xx files you've contributed.
>

really?
http://linuxtv.org/hg/v4l-dvb/rev/5f3c3af9c1f9

http://article.gmane.org/gmane.linux.drivers.dvb/44726

nevermind.

Markus
