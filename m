Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578AbYLYSxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbYLYSxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 13:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYLYSxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 13:53:39 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:61964 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbYLYSxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 13:53:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=N8JDI5f6MIr1HP27YRlHwFy0TnpaFd3I3dc5zKkdIJthoq5neNjT+02d1QN5HNeDkd
         U8LgvM7elJxKq9Rp2r57zdQvXGMrLumcM2bhtVcB5vV6WFYsPmnTLStN3oEbdSn4zZrq
         YiO/cZ71Xdz5cIXH86CS8g/HCeTAmpt1VJyYQ=
Message-ID: <ce0170d90812251053w46601ce4yb62765270abf0632@mail.gmail.com>
Date: Thu, 25 Dec 2008 15:53:36 -0300
From: "Sergio Luis" <eeeesti@gmail.com>
To: ronis@ronispc.chem.mcgill.ca
Subject: Re: Kernel panic with upgrade to 2.6.28
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1230230537.3368.13.camel@montroll.chem.mcgill.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1230230537.3368.13.camel@montroll.chem.mcgill.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 3:42 PM, David Ronis
<ronis@ronispc.chem.mcgill.ca> wrote:
> I just upgraded from 2.6.27.8 or .10 to 2.6.28 on several machines.  On
> one, a Dell dimension 3000 with a dual-core pentium R chip,  2 Seagate
> ST340014A (/dev/hda with swap as partion 1 and root ext3 filesystem as
> partion 2 and b containing a windows partition) and running slackware
> 12.1, I get a kernel panic when trying to boot (the others boot fine);
> specifically, I get:
>
>        Cannot open root device "302" or unknown block(3,2).  Please
>        append a correct root=; here are the available partitions:
>
> No partitions are shown.  Manually adding root=/dev/hda2 to the lilo
> boot prompt doesn't help either.
>
> The 2.6.27.8 kernel boots fine.
>
> Any suggestions?  Please CC me directly.
>
> Thanks and Happy Holidays
>
> David
>
>

Hello,

please send your config from both 2.6.27.8 and 2.6.28 kernel. Also the
dmesg from the working kernel. It might help with finding out what's
going on.

Happy Holidays too.

Sergio.
