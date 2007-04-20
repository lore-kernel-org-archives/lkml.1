Return-Path: <linux-kernel-owner+w=401wt.eu-S1750979AbXDTXsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750979AbXDTXsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 19:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbXDTXsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 19:48:43 -0400
Received: from styx.suse.cz ([82.119.242.94]:54818 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750979AbXDTXsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 19:48:42 -0400
Date: Sat, 21 Apr 2007 01:56:10 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: Vojtech Pavlik <vojtech@suse.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, edouard.tisserant@wanadoo.fr
Subject: Re: Acecad USB Tablet: usbmouse takeover and odd motion
In-Reply-To: <cb7bb73a0704201440i55557a13v5ad5a71617dc1239@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0704210150140.5138@jikos.suse.cz>
References: <cb7bb73a0704191940s1fd6487j9a4412aebd4342c0@mail.gmail.com> 
 <Pine.LNX.4.64.0704200903370.29846@jikos.suse.cz> 
 <cb7bb73a0704200126x1e7893fem5902fe79eefb70b7@mail.gmail.com> 
 <Pine.LNX.4.64.0704201533300.5138@jikos.suse.cz> 
 <cb7bb73a0704200855xe841ecdoc9a0f67fc6f7009e@mail.gmail.com> 
 <d120d5000704200901m44c9a3aei9ee0572c3b0a61ab@mail.gmail.com> 
 <cb7bb73a0704200909h2f47e04cq87cb3dd91d7144f7@mail.gmail.com> 
 <20070420204724.GB5334@suse.cz> <cb7bb73a0704201440i55557a13v5ad5a71617dc1239@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, Giuseppe Bilotta wrote:

> Oh, I see. I'll blacklist those modules, maybe also issue a ticket on 
> the Debian BTS.

If Debian enables usbmouse and usbkbd by default in their standard 
kernels, would you be so kind and raise a proper ticket on them not to do 
so? Thanks.

This also makes me to speed up with one of my items on TODO list - rename 
usbmouse and usbkbd to something that wouldn't be so confusing and 
wouldn't make people think that they should enable these drivers if they 
want support for USB keyboards/mice. Will queue this for 2.6.22.

-- 
Jiri Kosina
SUSE Labs
