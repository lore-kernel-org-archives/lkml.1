Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbYAGCCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbYAGCCs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 21:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYAGCCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 21:02:41 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:42957 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbYAGCCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 21:02:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rH/DqOIruWiO21pZvvo3YsqfLnHIT80NZTtF4u6Czno4GMWcji34U9l/Ps8uL3P3uncxPPZ0E88tK6gpjuZEkfLgkbCAma0U42+mnej0uwHMDFW1SrQuJFkHwLflJQmXwqLfhcxicLqRAPj/mf1nbM06ffMk8ihrI6IMiamzaeQ=
Message-ID: <68cac7520801061802h6bbb06f0naf12d223a28ac3d9@mail.gmail.com>
Date: Mon, 7 Jan 2008 00:02:37 -0200
From: "Douglas Landgraf" <dougsland@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [v4l-dvb-maintainer] [PATCH] Re: Regression: VIDIOCGMBUF ioctl hangs on bttv driver (2.6.24-rc6)
Cc: "Gregor Jasny" <jasny@vidsoft.de>, linux-kernel@vger.kernel.org,
       video4linux-list <video4linux-list@redhat.com>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       v4l-dvb-maintainer@linuxtv.org, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20080106232234.GA12783@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080105223338.GA18690@vidsoft.de>
	 <20080106141548.GB18690@vidsoft.de>
	 <68cac7520801061453w6906e510o5d53449e0b28f400@mail.gmail.com>
	 <20080106232234.GA12783@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

> this is about the bttv driver in 2.6.24-rc6/(rc7?) hanging. So whatever
> the devel tree does, this fix (if it's a correct fix) needs to be
> commited upstream ASAP.

You are right, my misunderstood. Sorry guys!

Cheers,
Douglas
