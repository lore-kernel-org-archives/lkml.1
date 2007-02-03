Return-Path: <linux-kernel-owner+w=401wt.eu-S1946412AbXBCIzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946412AbXBCIzy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 03:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946414AbXBCIzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 03:55:54 -0500
Received: from nz-out-0506.google.com ([64.233.162.236]:64072 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946412AbXBCIzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 03:55:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jt/DX6TY8UIfMa8RiR1TLxsySlcWbx7aAECTdCw4KqY5jxdOCSSlPJpAPKr90XZn7c1sy71G2HjD7e47iacnJvnDZtMA7VDaH9bT/dY4Q1WWcHb3fdWarFS9fxBGu3Tnnf+fayBmPilI76T0ZxMnSsmb0aJK3u2E2X9LrgExGKI=
Message-ID: <8d158e1f0702030055l39b7cc9eg6e9b36862a4b495d@mail.gmail.com>
Date: Sat, 3 Feb 2007 09:55:52 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: hdparm for lib_pata
In-Reply-To: <8d158e1f0702030041xaa34440r125a39a85d498f4c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8d158e1f0702030041xaa34440r125a39a85d498f4c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The problem is even worse, the drive falls back to PIO mode and there
is no way I can get it back to dma mode (like I could by using
hdparm). The only thing i can do is reboot the machine so it will see
the drive is UDMA capable.

If there is some beta/gamma software around or something you'd like to
have tested, you can mail me directly, my machine is your private
prostitute at the moment, it's not like i have something important to
do with the machine anyway (not related to this problem):)


Patrick
