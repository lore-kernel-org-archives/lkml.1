Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbZI3Tav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbZI3Tav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 15:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbZI3Tau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 15:30:50 -0400
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:57805 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbZI3Tat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 15:30:49 -0400
Date: Wed, 30 Sep 2009 15:30:46 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: [PATCH] media/video:  adding __init/__exit macros to various
 drivers
In-reply-to: <A69FA2915331DC488A831521EAE36FE4015536F6E8@dlee06.ent.ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: Peter Huewe <PeterHuewe@gmx.de>, Jiri Kosina <trivial@kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
       Hans Verkuil <hverkuil@xs4all.nl>, Andy Walls <awalls@radix.net>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Michael Krufky <mkrufky@kernellabs.com>,
       Martin Dauskardt <martin.dauskardt@gmx.de>,
       "Beholder Intl. Ltd. Dmitry Belimov" <d.belimov@gmail.com>,
       "ivtv-devel@ivtvdriver.org" <ivtv-devel@ivtvdriver.org>,
       "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Message-id: <4AC3B1E6.5010509@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <200909290219.01623.PeterHuewe@gmx.de>
 <200909301002.35202.laurent.pinchart@ideasonboard.com>
 <A69FA2915331DC488A831521EAE36FE4015536F6E8@dlee06.ent.ti.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US;
 rv:1.9.1.4pre) Gecko/20090915 Thunderbird/3.0b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/30/09 9:26 AM, Karicheri, Muralidharan wrote:

drivers/media/video/saa7164/saa7164-core.c

drivers/media/video/cx23885/cx23885-core.c

Acked-By: Steven Toth <stoth@kernellabs.com>

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
