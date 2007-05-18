Return-Path: <linux-kernel-owner+w=401wt.eu-S1763223AbXERRJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763223AbXERRJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 13:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757398AbXERRJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 13:09:43 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:45920 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757364AbXERRJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 13:09:42 -0400
Message-ID: <464DDDC1.5060008@drzeus.cx>
Date: Fri, 18 May 2007 19:09:21 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [RFC][PATCH] Make prepare_namespace() wait for devices
References: <464853D9.70904@drzeus.cx> <p73ejlednk0.fsf@bingen.suse.de>
In-Reply-To: <p73ejlednk0.fsf@bingen.suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there brave visitor from the future ;)

Andi Kleen wrote:
> Actually that's not correct. With panic=30 and lilo -R and a working 
> backup kernel a system can recover from this. With your endless loop it can't.
>
> Always add some kind of timeout.
>
>   

Did you check the second version? Is that sufficient or is a timeout a
must in your book?

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

