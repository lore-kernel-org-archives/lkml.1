Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbXKBRle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbXKBRle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbXKBRl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:41:27 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:39222 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbXKBRl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:41:26 -0400
Date: Fri, 2 Nov 2007 18:39:51 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Romano Giannetti <romanol@upcomillas.es>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc1 eat my photo SD card :-(
Message-ID: <20071102183951.06c1b468@poseidon.drzeus.cx>
In-Reply-To: <472A0A36.1050403@redhat.com>
References: <1193918202.8439.7.camel@rukbat>
	<472A0A36.1050403@redhat.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Nov 2007 13:17:42 -0400
Chuck Ebbert <cebbert@redhat.com> wrote:

> 
> I always flip the write-protect switch when I use mine with a computer,
> and only let the camera write to the card.

Just so noone gets any optimistic ideas, that switch is software enforced so it's no guarantee against bugs. 

(But since my code is bug free, that shouldn't be an issue. ;))

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
