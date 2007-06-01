Return-Path: <linux-kernel-owner+w=401wt.eu-S1762984AbXFASQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762984AbXFASQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761924AbXFASQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:16:16 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:22168 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760073AbXFASQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:16:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Pm6O2J/TMe/SE2GyXv0GRr5aX3CUFwAmbm1eGySGf1P+9uTjdWM1yl50pDNd4n/5Ou0wf/5k0ObcIu8P4qAGYGbBp0xL52lqivnl4Z/94yIlu1H0DO135bP5Xodnf7/CYu/v11pkUJgmiBBdcVoNIvFEayHr/jUtRm6EjzMFyXs=
Message-ID: <d9b9d95f0706011116j59fff917x9a86aac377f88937@mail.gmail.com>
Date: Fri, 1 Jun 2007 19:16:12 +0100
From: "Renato Golin" <rengolin@gmail.com>
To: "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: joydev.c and saitek cyborg evo force
Cc: linux-kernel@vger.kernel.org,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0705312220250.5177@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9b9d95f0705180654x342ff6dbwf134243dfeabed20@mail.gmail.com>
	 <Pine.LNX.4.64.0705211444500.22906@jikos.suse.cz>
	 <d9b9d95f0705291657o47ef42d3jea2a1dae3e31bbdb@mail.gmail.com>
	 <Pine.LNX.4.64.0705300207160.3961@jikos.suse.cz>
	 <d9b9d95f0705300214u7eb257fg783aefd73077d33@mail.gmail.com>
	 <Pine.LNX.4.64.0705301654560.3961@jikos.suse.cz>
	 <d9b9d95f0705300818h2eaa8130mf8a7a37966d29cc5@mail.gmail.com>
	 <d9b9d95f0705301526i66e99ef3v6c35165aa1a5f5c6@mail.gmail.com>
	 <d120d5000705311253n67d4247eh194e6f4457a0b4c@mail.gmail.com>
	 <Pine.LNX.4.64.0705312220250.5177@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/05/07, Jiri Kosina <jkosina@suse.cz> wrote:
> Yes, the problem with axis ranges definitely looks like that. Renato,
> could you please send me vendor id and product id of the joystick in
> question, I will send you a patch to test whether normalizing the values
> on hid-level (as we already do for several other joypads) will do the
> trick?

Hi Jiri,

06a3:ffb5 Saitek PLC

I'm using 2.6.20 and compiling new kernels for Ubuntu is a nightmare.
Also, would be good not to need additional parameters for the general
public.

cheers,
--renato

Reclaim your digital rights, eliminate DRM, learn more at
http://www.defectivebydesign.org/what_is_drm
