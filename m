Return-Path: <linux-kernel-owner+w=401wt.eu-S1762697AbYA3RII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762697AbYA3RII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 12:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbYA3RH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 12:07:56 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:53958 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbYA3RHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:07:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uIpFBOA6+gadzlj76dN1jCxXAFrEFLfEdirRVyuBZv7iN4tgIfv6kKL/sgh1DVyTtx/3nekk4Ucb8u1oyM89jAb27LwsIEuQuOXu9xgDyO/xlPOpZHL456btKCjSB9AXx/ZMeD2hiOfclFDcgLBsxcAh30T7itb/d38YJSFdUkA=
Message-ID: <386072610801300907t5c0ee532tbe5696d48dad6b5c@mail.gmail.com>
Date: Thu, 31 Jan 2008 01:07:52 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Will Newton" <will.newton@gmail.com>
Subject: Re: [PATCH 1/1] [INPUT] keypad driver: Added support for OpenCores Keyboard Controller
Cc: "Bryan Wu" <bryan.wu@analog.com>, dmitry.torokhov@gmail.com,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       "Javier Herrero" <jherrero@hvsistemas.es>
In-Reply-To: <87a5b0800801300353l196b39bekad6af6ccdbd49d5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1201686610-31458-1-git-send-email-bryan.wu@analog.com>
	 <87a5b0800801300353l196b39bekad6af6ccdbd49d5b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30, 2008 7:53 PM, Will Newton <will.newton@gmail.com> wrote:
> On Jan 30, 2008 9:50 AM, Bryan Wu <bryan.wu@analog.com> wrote:
>
> > +config KEYBOARD_OPENCORES
> > +       tristate "OpenCores Keyboard Controller"
> > +       help
> > +         Say Y here if you want to use the OpenCores Keyboard Controller
> > +         http://www.opencores.org/projects.cgi/web/keyboardcontroller/overview
> > +
> > +         To comile this driver as a module, choose M here. the
> > +         module will be called opencores-kbd.
> > +
>
> Typo, "comile" should be "compile" here.
>

Thanks, fix it now. I will update this patch soon.

-Bryan
