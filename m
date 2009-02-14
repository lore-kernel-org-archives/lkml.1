Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbZBNN54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbZBNN54 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 08:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbZBNN5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 08:57:46 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:34906 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbZBNN5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 08:57:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=WlJJtCumx34J1f0vu7kwM1x6tqSx2Wv7zJFjWB1JUqL7/W92DpqOpmanLdWbQzIlw1
         6xNmJrwq597uT6+TLqjYtbekZSPkND6xYlrSsJRvUsNku/s9hHG7brFvHF9UApZz5GBh
         a0zz2Zrl0SwshRer4oKg1z1ugWCezKtQ3vDAk=
MIME-Version: 1.0
In-Reply-To: <2c0942db0902061050u4a854958u7e7a2db60e67baa6@mail.gmail.com>
References: <6bd94bae0901310536l2cd42fa1off60ee066fa0096b@mail.gmail.com>
	 <20090131134651.GC28763@khazad-dum.debian.net>
	 <6bd94bae0901310604u6ed876f1n77b7e2561f479ad1@mail.gmail.com>
	 <6bd94bae0901310651k6a85e2a8g280308da272bdaf7@mail.gmail.com>
	 <20090201014453.GC22841@khazad-dum.debian.net>
	 <6bd94bae0902061008n251d6bb9g9b9ec5bc791dc9ae@mail.gmail.com>
	 <2c0942db0902061050u4a854958u7e7a2db60e67baa6@mail.gmail.com>
Date: Sat, 14 Feb 2009 14:57:44 +0100
Message-ID: <6bd94bae0902140557t7de20d1eia22ba51e49793ad8@mail.gmail.com>
Subject: Re: Spurious Filesystem corruption with ext3 + large (<400GB) hw RAID 
	partition + SMP
From: Manfred Wassmann <tux.wassmann@googlemail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 6, 2009 at 19:50, Ray Lee <ray-lk@madrabbit.org> wrote:
> Huh. It may be related to whatever kernel version Ubuntu uses to boot
> up the install media. Try a different version of Ubuntu (older, newer
> if a newer one exists) to see if it has the same problem

Apparently google mail junks any references headers when replying to a
mail with a modified subject, how bad is that!
In short for those who didn't get it, the problem was neither an ext3
nor a Ubuntu problem but apparently an obscure hardware problem,
details can be found in
<6bd94bae0902130829r15e6eacag25220487457027ad@mail.gmail.com>

Regards Manfred
