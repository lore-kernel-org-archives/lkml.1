Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbZHKMYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbZHKMYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbZHKMYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:24:37 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:59385 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbZHKMYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:24:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bC8gSxcpEBV7eiP69GVDCvBRIl9gSEfEwQJa9jlt//ehqUa09GBnqRWc8g1+x9Owbf
         2iZFSNbdk9S5cOJ3cMnkFdop9Ts7gWBTj98rLwPkmbAc/sndPpOs4DmrBCUbBfOk6W+c
         SAtWyNghe/xxYllk1oZZuPzJv6jgZd+N7vyds=
MIME-Version: 1.0
In-Reply-To: <4A801644.2070009@gefanuc.com>
References: <20090803205657.964064732@mini.kroah.org> <20090803210111.GB28430@kroah.com> 
	<20090808230145.GB27151@braap.org> <4A801644.2070009@gefanuc.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 11 Aug 2009 00:54:34 -0400
Message-ID: <8bd0f97a0908102154t3b0f393bg941a16e2f14a03b7@mail.gmail.com>
Subject: Re: [patch 1/5] Staging: VME Framework for the Linux Kernel
To: Martyn Welch <martyn.welch@gefanuc.com>
Cc: "Emilio G. Cota" <cota@braap.org>, Greg K-H <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Sebastien Dugue <sebastien.dugue@bull.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 08:44, Martyn Welch wrote:
> For using the VME bus for communication between two SBCs, I think we could
> use the CRCSR space to provide some information about the resources used on
> each board for say, a virtual network driver like the rapidIO subsystem
> provides. Possibly using the "device tree" stuff used on PowerPC, Blackfin
> and Sparc archs (I believe) for passing device layout between the firmware
> and kernel at boot.

Blackfin doesnt use device trees and there are no plans to do so
-mike
