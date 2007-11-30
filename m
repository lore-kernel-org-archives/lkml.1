Return-Path: <linux-kernel-owner+w=401wt.eu-S1757179AbXK3Xwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbXK3Xwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758096AbXK3Xv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:51:58 -0500
Received: from hu-out-0506.google.com ([72.14.214.238]:46241 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285AbXK3Xv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:51:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:to:subject:cc:message-id:date:from;
        b=BPyg3gJ4UQCKrWecbWYjZZ3bTFgSjAKat+QY2GMl+GqkR8vpldjVBZVIUMAU36dS1tpCBJ/PqCdL7Pvao8WzbSPNetAlSCNSBiLhhDzC+KjDJjQu/REcc7XTi0ypwDmBYu1pv2ut610mJ0miDZb4AT4xKZ9Qh8R0Y6WXE2qH49w=
To: alan@lxorguk.ukuu.org.uk, msar2020@gmail.com
Subject: Re: [PATCH] ipwireless_cs driver for 4G PC Card
Cc: akpm@linux-foundation.org, benm@symmetric.co.nz, dsterba@suse.cz,
       jeff@garzik.org, jkosina@suse.cz, jslaby@suse.cz,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       stephen@symmetric.co.nz
Message-Id: <20071130234958.5E49719E20E@silentrunning.homelinux.org>
Date: Fri, 30 Nov 2007 23:49:58 +0000 (GMT)
From: msar2020@gmail.com (Michael Robb)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>At the moment they seem to be ending up under serial, so I would prefer
>consistency between the USB tty interfaces for 3G cards, the stuff like
?Nozomi and any newer goodies.

That makes sense - I was wondering how the device drivers are going to
be categorised given that the same hardware can be interface to the system
either through pcmicia, USB ports, or hardwired directly onto the motherboard.

- Michael
