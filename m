Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbXLIC31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbXLIC31 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 21:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbXLIC3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 21:29:19 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:47093 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbXLIC3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 21:29:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fkJFF2zRb9Of5IjnfKy33IyBpXMhkdTHdyt/KBiZpvNOnRthsU2wdwSNn0I57bAV/ilZmdhoR2GyAdPQgaPL5tbB9G/H7TauUzxnbPKjaJpAmQ2AmKqTLNlzODm7ZI+OLvjbG/PmFz2qjt/3wHe5i5r+2RZb5Z+ZG7DAie//V2Y=
Message-ID: <a44ae5cd0712081829r3d3e0436qc9e55e3b5ca42f63@mail.gmail.com>
Date: Sat, 8 Dec 2007 21:29:18 -0500
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc4-mm1 -- boot process hangs -- tty4 main process (2988) terminated with status 1
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071207021556.ce08dfa6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0712061956i1bd8f354rbfcffdbafad2e5d8@mail.gmail.com>
	 <20071207021556.ce08dfa6.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Dec  6 21:24:28 erratic-orbits init: tty3 main process (2991)
> > terminated with status 1
>
> Boggle.  We broke the vt driver?
>
> config, please...

I sent the .config.  Is there nothing else to follow up on?  I have
tried rebuilding about seven kernels, tweaking the options each time.
All the kernels have failed to boot.   I am currently trying with a
"defconfig" kernel.  Perhaps I will have better luck with it.

Thanks,
           Miles
