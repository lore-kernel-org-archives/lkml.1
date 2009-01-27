Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbZA0HqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbZA0HqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 02:46:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbZA0Hp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 02:45:56 -0500
Received: from mail.netone.net.tr ([193.192.98.182]:23993 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbZA0Hpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 02:45:55 -0500
Message-ID: <497EBBB1.5020609@turknet.net.tr>
Date: Tue, 27 Jan 2009 09:45:53 +0200
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>
Subject: Re: [BUG] tg3 module problem on Linux-2.6.29-rc1-2
References: <49771D65.3090205@turknet.net.tr>	 <20090121152818.GA3438@x200.localdomain>	 <497870A3.4070200@turknet.net.tr> <3f9a31f40901262230s3efb9242jcd4a02ee84944daa@mail.gmail.com>
In-Reply-To: <3f9a31f40901262230s3efb9242jcd4a02ee84944daa@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jan 2009 07:45:53.0629 (UTC) FILETIME=[480E08D0:01C98053]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> Is this ubuntu's specific problem or you also getting these
> warnings/errors on another releases.
>
>   
Yes,it's specific to Ubuntu's kernel build process (make-kpkg). I had no 
time to try with regular kernel build process. But; if it's necessary, I 
can try it out. BTW, my box is Kubuntu 8.10 with latest updates.
