Return-Path: <linux-kernel-owner+w=401wt.eu-S1759809AbXFJSfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759809AbXFJSfT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 14:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754983AbXFJSfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 14:35:05 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:3055 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953AbXFJSfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 14:35:04 -0400
Date: Sun, 10 Jun 2007 20:35:03 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Greg KH <gregkh@suse.de>, Jesper Juhl <jesper.juhl@gmail.com>,
       Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       linux-kernel@vger.kernel.org, m-ikeda@ds.jp.nec.com
Subject: Re: kconfig .po files in kernel tree? [Was: Documentation/HOWTO
 translated into Japanese]
In-Reply-To: <20070610175228.GA28947@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0706102034490.25718@fbirervta.pbzchgretzou.qr>
References: <20070610.204845.115909592.tshibata@ab.jp.nec.com>
 <9a8748490706100524o2dff1954ja7406f9303d8499f@mail.gmail.com>
 <20070610162221.GA12830@suse.de> <20070610175228.GA28947@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 10 2007 19:52, Sam Ravnborg wrote:
>> >  Since the common language of most kernel contributors is english I
>> >  personally feel that we should stick to just that one language in the
>> >  tree and then perhaps keep translations on a website somewhere. So the
>> >  authoritative docs stay in the tree, in english, so that as many
>> >  contributors as possible can read and update them. It would then be a
>> >  seperate project to generate translations and keep them updated
>> >  according to what's in the tree.  Perhaps we could get the kernel.org
>> >  people to create an official space for that and then place a pointer
>> >  to that site in Documentation/ somewhere.
>> 
>> No, I think the translated files should be in the tree proper, we have
>> the space :)
>
>We once discussed about .po files for kconfig and back then
>the conclusion was not to keep them in the kernel tree.
>
>I advocated that they should stay out back then.
>But on the other hand I do not see it causing much troubles
>having scripts/kconfig/po/da.po etc araound.
>
>Any opinion about the .po files?

Like with translated doc, they might get out of date easily.


	Jan
-- 
