Return-Path: <linux-kernel-owner+w=401wt.eu-S1757123AbZBJXzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123AbZBJXzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 18:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZBJXzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 18:55:00 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:15466 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZBJXy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 18:54:59 -0500
X-Greylist: delayed 500 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Feb 2009 18:54:59 EST
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <499213CD.6080903@tremplin-utc.net>
Date: Wed, 11 Feb 2009 00:54:53 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: git@vger.kernel.org, Pavel Machek <pavel@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] lis3lv02d: support both one- and two-byte sensors
References: <1234309249-13672-1-git-send-email-giuseppe.bilotta@gmail.com>	 <499211D0.3090705@tremplin-utc.net> <cb7bb73a0902101551o30dde0aesaeba399f1ab732af@mail.gmail.com>
In-Reply-To: <cb7bb73a0902101551o30dde0aesaeba399f1ab732af@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giuseppe Bilotta schreef:

> Well, the previous one works, but I admit it's horribly convoluted.
> I'll double check with this one and resubmit (I'll only resubmit the
> one based on Pavel's "don't touch anything on init" probably though,
> hope it's ok)
Sure, only modified v3 is ok.
BTW, now that this is working. Could you double check the correct axes 
set up. In particular, is it x_inverted or y_inverted, and what about z 
axis...

Thanks,
Eric
