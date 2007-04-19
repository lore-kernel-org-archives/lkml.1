Return-Path: <linux-kernel-owner+w=401wt.eu-S1031102AbXDSEZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031102AbXDSEZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 00:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031111AbXDSEZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 00:25:43 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:43402 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031102AbXDSEZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 00:25:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kRJ1luQSkA+OnfTi1ZbVPQk2vzXMbiwImLZUXPAsysgb1MjL3Y1ZsjRnCvrinVFUJO3AAqZmTanRNvNvG9gdPStzlhxzhR2oVM7YTv5UiMoY2zVh1GhTo/s1takhK6u1/2iNoUrkafSeFOzXptZeB/9B1cSDajli6vlddlNORAI=
Message-ID: <38b3b7c0704182125q1928c5barad21ed603088ab04@mail.gmail.com>
Date: Thu, 19 Apr 2007 06:25:41 +0200
From: "johann deneux" <johann.deneux@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [RFC 1/2] Input: ff, add FF_RAW effect
Cc: linux-kernel@vger.kernel.org, "Dmitry Torokhov" <dtor@insightbb.com>,
       stenyak@gmail.com, linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <462688AB.4060707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <210731960111436322@karneval.cz>
	 <38b3b7c0704181300p78df84f3h8fd4e74428d4e4d8@mail.gmail.com>
	 <462688AB.4060707@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/18/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> johann deneux napsal(a):
> > Jiri,
> >
> > Which solution did you chose to implement? From what I remember, we
> > last discussed Dmitry's idea of specifying an axis for an effect, then
> > combine several effects to achieve complex effects.
>
> I think you mean motor instead of axis, because I don't push real axes to
> the devices, but motor's torques...
>

Yes, sorry, I meant motor.

-- 
Johann
