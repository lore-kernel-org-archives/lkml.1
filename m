Return-Path: <linux-kernel-owner+w=401wt.eu-S1758827AbXHKRid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827AbXHKRid (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 13:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbXHKRiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 13:38:23 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:35039 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbXHKRiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 13:38:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ESO8GLIE0XBEEx2QEaSqPJUyQJ66UZa7tWs3g4DXOSE9i7bSFgw03Lse7GYczFPECgRJ0+ABtBr10UU1LwkW0O4orCeUdpF3z4PTj/lxQs6DMq4+5jJ4u4ECb9RLETvMWUbBuR27kUbXw264Siu6blVECaoYQ5ZJ9JQoEG8GVug=
Message-ID: <d9b9d95f0708111038p48f18660me02d3e75280b37e@mail.gmail.com>
Date: Sat, 11 Aug 2007 18:38:20 +0100
From: "Renato Golin" <rengolin@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: joydev.c and saitek cyborg evo force
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708101753410.11054@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com>
	 <d9b9d95f0706120608g979b89oc79dbc277d19862b@mail.gmail.com>
	 <d120d5000706120613o7a328e59v3cba37f0ced88e77@mail.gmail.com>
	 <d9b9d95f0706120631l20e6f91duaa110e72a0e955a6@mail.gmail.com>
	 <Pine.LNX.4.64.0706121715480.10204@jikos.suse.cz>
	 <d9b9d95f0706141524p3686a41cn882d8f086e4f62cc@mail.gmail.com>
	 <Pine.LNX.4.64.0706201156410.23812@jikos.suse.cz>
	 <d9b9d95f0707201710g14d8a905s222c1209358f0196@mail.gmail.com>
	 <Pine.LNX.4.64.0708101643360.11054@jikos.suse.cz>
	 <Pine.LNX.4.64.0708101753410.11054@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/07, Jiri Kosina <jkosina@suse.cz> wrote:
> does the attached patch (against 2.6.23-rc2) fix the problem with axis
> ranges for you please?

Hi Jiri,

fixes perfectly. But it probably breaks the output range and kills the
force-feedback.

I couldn't find fftest for debian (the package with jstest doesn't
have it) but I'll compile and run here to test.

thanks,
--renato

Reclaim your digital rights, eliminate DRM, learn more at
http://www.defectivebydesign.org/what_is_drm
