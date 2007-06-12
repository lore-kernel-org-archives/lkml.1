Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbXFLM2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbXFLM2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 08:28:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbXFLM2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 08:28:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:41244 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbXFLM2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 08:28:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PnzemHlfGE9HKyBURKdg6MQdtNw/yQAneSSwpOxJT9KtvT1A8xK8U0221sfc6fXnlr1HfNrTDGiIvWqAD3zMAoBOxgFhinT9SPBAG+KoY2yNsH/+y2g303bZHkbYv53MpIiHEKoDN8ynvvzceCG2J8I2LyLfp+XSpCWVRPMRcsQ=
Message-ID: <d9b9d95f0706120528k20ff8feem507efa54e6ac6824@mail.gmail.com>
Date: Tue, 12 Jun 2007 13:28:28 +0100
From: "Renato Golin" <rengolin@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: joydev.c and saitek cyborg evo force
Cc: linux-kernel@vger.kernel.org,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
In-Reply-To: <d9b9d95f0706041546h4eef0b4eo2e191968be13d59a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com>
	 <d9b9d95f0705300818h2eaa8130mf8a7a37966d29cc5@mail.gmail.com>
	 <d9b9d95f0705301526i66e99ef3v6c35165aa1a5f5c6@mail.gmail.com>
	 <d120d5000705311253n67d4247eh194e6f4457a0b4c@mail.gmail.com>
	 <Pine.LNX.4.64.0705312220250.5177@jikos.suse.cz>
	 <d9b9d95f0706011116j59fff917x9a86aac377f88937@mail.gmail.com>
	 <Pine.LNX.4.64.0706031139570.5177@jikos.suse.cz>
	 <d9b9d95f0706041506l257819a7pbcb8b8efc2eec049@mail.gmail.com>
	 <Pine.LNX.4.64.0706050008160.5177@jikos.suse.cz>
	 <d9b9d95f0706041546h4eef0b4eo2e191968be13d59a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/07, Renato Golin <rengolin@gmail.com> wrote:
> > Well calibration using jscal might be needed, that should be fine. The
> > question is whether the ranges are now correct and calibration using jscal
> > works fine.
>
> Ok, so maybe in that case my automatic calibration is still worth to
> put on joydev.c
> and users from all joysticks in the quirk list would benefit.

Hi Dmitry,

The patch to joydev.c was updated on Andrew's list do you see any
problem with it?

cheers,
--renato

Reclaim your digital rights, eliminate DRM, learn more at
http://www.defectivebydesign.org/what_is_drm
