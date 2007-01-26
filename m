Return-Path: <linux-kernel-owner+w=401wt.eu-S1161164AbXAZSbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161164AbXAZSbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:31:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161160AbXAZSbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:31:04 -0500
Received: from nz-out-0506.google.com ([64.233.162.236]:1292 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161162AbXAZSbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:31:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=dxcmX7x1B/6PB7FvQYqEr5stipIPxZUrnZqMQE4sjI9C95d0FFFspG6pO9q561/ANjmhxfg/PkcpvDXo/4Ft8QfbLb31rFRmgDopt9WljOe8wFMoE5bc0rfNPXwD3lhrfyV197f6tTSbKhlvcvd4VrVY0OZ6fsosgS3xHHs1DYU=
Message-ID: <806dafc20701261031p1d6af7ave660c293dc290b30@mail.gmail.com>
Date: Fri, 26 Jan 2007 13:31:01 -0500
From: xiphmont@xiph.org
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [Alsa-devel] [PATCH] alsa: correct nonsensical sysfs device symlinks
Cc: "Greg KH" <greg@kroah.com>, "Pierre Ossman" <drzeus@drzeus.cx>,
       fedora-desktop-list@redhat.com, alsa-devel@alsa-project.org,
       jrb@redhat.com, linux-kernel@vger.kernel.org, mclasen@redhat.com,
       "Lennart Poettering" <lennart@poettering.net>, perex@suse.cz
In-Reply-To: <s5hd5511w81.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <806dafc20701251007n69bc9b3cse023b51369501d42@mail.gmail.com>
	 <s5h1wljuf2f.wl%tiwai@suse.de>
	 <806dafc20701251051p2750cb34sab88a38282020497@mail.gmail.com>
	 <20070125194933.GA27857@kroah.com>
	 <806dafc20701251240t70335055l74c47ecdd09d1944@mail.gmail.com>
	 <20070125215943.GC3126@kroah.com>
	 <806dafc20701260253r145fee43kc6db1ca6de1ab3e6@mail.gmail.com>
	 <s5hejpivwwg.wl%tiwai@suse.de> <20070126180457.GA29543@kroah.com>
	 <s5hd5511w81.wl%tiwai@suse.de>
X-Google-Sender-Auth: 8f5af25cb2937155
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, working on testing all cases here, takes a while, kernel builds
are hella long on this machine.

Monty
