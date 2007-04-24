Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbXDXIe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbXDXIe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbXDXIe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:34:59 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:28837 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbXDXIe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:34:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NLKFOHgqqW/hfmMV9hvljFzS5wZO3MrarYuA3wbY4UkYLDqiDRvynqVUDBz0gHjtiFecQJYhiyAYAtbdEhn4n5Q9IFPkdrP8BnGgTD92Gx8nCSUPj8w3m7uMzh5p6njR5pinNCOb1woJuvOh8HHJh0sQHYednsBvTpFFOI88LUM=
Message-ID: <6bffcb0e0704240134w45007473p5694718a0aae08fc@mail.gmail.com>
Date: Tue, 24 Apr 2007 10:34:56 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "William Heimbigner" <icxcnika@mar.tar.cc>
Subject: Re: cpufreq default governor
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0704240755230.25153@server.thyself>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0704240755230.25153@server.thyself>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi William,

On 24/04/07, William Heimbigner <icxcnika@mar.tar.cc> wrote:
> Question: is there some reason that kconfig does not allow for default
> governors of conservative/ondemand/powersave?

Performance?

> I'm not aware of any reason why one of those governors could not be used
> as default.

My hardware doesn't work properly with ondemand governor. I hear
strange noises when frequency is changed.

>
> William Heimbigner
> icxcnika@mar.tar.cc

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
