Return-Path: <linux-kernel-owner+w=401wt.eu-S1758074AbXIFTG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074AbXIFTG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 15:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755757AbXIFTGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 15:06:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:20780 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbXIFTGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 15:06:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OvxvuTLQze4Ucin7dL9YIDPsOW10mCHpciBtg1vjW+kq2ryeu/1ylKwm+oHUVShmph7iLNn5NxXQL+vg4yMdhnyWstiawO2n2Qy1qOGHN7dxTS/W+aT7JSzGktJ3zYl8bxpcHEUeoNY7ovAlF6UPzPn9sLxRVovwlUAkOtE21ps=
Message-ID: <6bffcb0e0709061206n4146da2anf11f15218e8e0091@mail.gmail.com>
Date: Thu, 6 Sep 2007 21:06:49 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: webmaster@dragonslave.de
Subject: Re: Kernel Panic on 2.6.23-rc5
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200709062044.54626.dex@dragonslave.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200709062044.54626.dex@dragonslave.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 06/09/07, Daniel Exner <dex@dragonslave.de> wrote:
> Hi!
>
> I'm not really sure if this is a regression or if I simply hit a hardware
> problem.
> After some time of work (mostly hours sometimes minutes) my system will freeze
> including Blinking LED's and unresponsiveness on SysRQ, but I finally got
> this using netconsole:
>
> CPU 0: Machine Check Exception: 0000000000000004
> Bank 4: b200000000070f0f
> Kernel panic - not syncing: CPU context corrupt

It is a hardware problem.

You may want to use mcelog ftp://ftp.x86-64.org/pub/linux/tools/mcelog/

>
> I Also keep getting ext3 errors about reading or writing in wrong zones.
> Will now have a - this means many - run of memtest.
>
> --
> Greetings
> Daniel Exner

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
