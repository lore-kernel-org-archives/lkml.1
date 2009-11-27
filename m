Return-Path: <linux-kernel-owner+w=401wt.eu-S1751971AbZK0Ag6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbZK0Ag6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 19:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZK0Ag6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 19:36:58 -0500
Received: from khc.piap.pl ([195.187.100.11]:53639 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbZK0Ag5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 19:36:57 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Jarod Wilson <jarod@redhat.com>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Mario Limonciello <superm1@ubuntu.com>,
       "linux-input\@vger.kernel.org" <linux-input@vger.kernel.org>,
       "linux-media\@vger.kernel.org" <linux-media@vger.kernel.org>,
       Janne Grunau <j@jannau.net>, Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <200910200958.50574.jarod@redhat.com>
	<4B0A765F.7010204@redhat.com> <4B0A81BF.4090203@redhat.com>
	<m36391tjj3.fsf@intrepid.localdomain>
	<20091123173726.GE17813@core.coreip.homeip.net>
	<m3r5rpq818.fsf@intrepid.localdomain>
	<20091126052155.GD23244@core.coreip.homeip.net>
	<m31vjlw54x.fsf@intrepid.localdomain>
	<1F6BE32B-13EE-4FB4-96AD-D4526F435777@gmail.com>
	<m3d434su2o.fsf@intrepid.localdomain>
	<20091127002645.GH6936@core.coreip.homeip.net>
Date: Fri, 27 Nov 2009 01:37:01 +0100
In-Reply-To: <20091127002645.GH6936@core.coreip.homeip.net> (Dmitry Torokhov's
	message of "Thu, 26 Nov 2009 16:26:45 -0800")
Message-ID: <m3zl68refm.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:

> There is nothing in input layer that precludes you from creating
> multiple input devices per *whatever*.

Of course. I though it was obvious I mean present situation with the
media drivers but I can see now it was far from being obvious.
-- 
Krzysztof Halasa
