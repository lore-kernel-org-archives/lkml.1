Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbYJGL5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbYJGL5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYJGL5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:57:10 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59616 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474AbYJGL5J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:57:09 -0400
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: David Brownell <david-b@pacbell.net>,
       "me@felipebalbi.com" <me@felipebalbi.com>
CC: Carlos Chinea <carlos.chinea@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Tue, 7 Oct 2008 06:56:53 -0500
Subject: RE: [RFC][PATCH 2/5] OMAP SSI driver interface
Thread-Topic: [RFC][PATCH 2/5] OMAP SSI driver interface
Thread-Index: AckoGOPXxpBdrhLvTLeCTdI5l4MtIgAWl4kQ
Message-ID: <13B9B4C6EF24D648824FF11BE89671620365AE0FB8@dlee02.ent.ti.com>
References: <1223034606.32631.156.camel@groo.research.nokia.com>
 <1223034750-18690-2-git-send-email-carlos.chinea@nokia.com>
 <20081006232931.GE8273@frodo> <200810061803.06731.david-b@pacbell.net>
In-Reply-To: <200810061803.06731.david-b@pacbell.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> owner@vger.kernel.org] On Behalf Of David Brownell
> On Monday 06 October 2008, Felipe Balbi wrote:
> > looks much better and much easier to type: #include <linux/ssi.h>
>
> Does this work on non-OMAP kernels?  If not, <mach/ssi.h> or
> similar would seem more sensible ...

Seems like some cousin might be multi vendor via MIPI HSI. http://www.mipi.org/wgoverview.shtml


Regards,
Richard W.

