Return-Path: <linux-kernel-owner+w=401wt.eu-S940478AbXHJQcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940478AbXHJQcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932345AbXHJQcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:32:01 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:62993 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765275AbXHJQcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:32:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SyHgCwrT5izZrmxXXmEiqphenuTrZtv7Cn66yhnF4d8YE0VwFfyUfq6RxryT7gugJeSdbcsegn1sz5k+pFjUZuc46nl/bIpQoIxQpB7ekF+2LhKQ3yg5sNgNrjZqQg3pVJdqYQO3me39RFnLT8QD1dvbFBCL38x2iAr9msu7jo8=
Message-ID: <d9b9d95f0708100931q3fad7f45la3e4046fa650482f@mail.gmail.com>
Date: Fri, 10 Aug 2007 17:31:58 +0100
From: "Renato Golin" <rengolin@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: joydev.c and saitek cyborg evo force
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708101643360.11054@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com>
	 <Pine.LNX.4.64.0706121436070.10204@jikos.suse.cz>
	 <d9b9d95f0706120608g979b89oc79dbc277d19862b@mail.gmail.com>
	 <d120d5000706120613o7a328e59v3cba37f0ced88e77@mail.gmail.com>
	 <d9b9d95f0706120631l20e6f91duaa110e72a0e955a6@mail.gmail.com>
	 <Pine.LNX.4.64.0706121715480.10204@jikos.suse.cz>
	 <d9b9d95f0706141524p3686a41cn882d8f086e4f62cc@mail.gmail.com>
	 <Pine.LNX.4.64.0706201156410.23812@jikos.suse.cz>
	 <d9b9d95f0707201710g14d8a905s222c1209358f0196@mail.gmail.com>
	 <Pine.LNX.4.64.0708101643360.11054@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/07, Jiri Kosina <jkosina@suse.cz> wrote:
> Renato, does force feedback work properly in Linux with this device? If
> so, that would mean that the device has logical maximum and minimum for X
> and Y axes different in input and output, and we would need to handle this
> properly (we currently don't).

Hi Jiri,

Makes total sense to me.

I've never tried force-feedback with it (or it never worked) as I
don't know which games support it (I thought none did).

I'll apply the patch and let you know.

thanks!
--renato

Reclaim your digital rights, eliminate DRM, learn more at
http://www.defectivebydesign.org/what_is_drm
