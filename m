Return-Path: <linux-kernel-owner+w=401wt.eu-S1760654AbYCESDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760654AbYCESDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 13:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbYCESDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 13:03:01 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:36829 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188AbYCESC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 13:02:59 -0500
Date: Wed, 5 Mar 2008 19:01:25 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080305190125.7417d4ff@mjolnir.drzeus.cx>
In-Reply-To: <47CED91F.4020106@goop.org>
References: <a2itf-5jB-27@gated-at.bofh.it>
	<493b45a1-bb40-4e3c-9a8e-4b6ee7b8fdc3@b1g2000hsg.googlegroups.com>
	<20080301132924.0dc22b36@mjolnir.drzeus.cx>
	<47CED91F.4020106@goop.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2008 09:32:15 -0800
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> 
> More likely inductors, I think.  The coils can vibrate against the coil 
> if they haven't been properly potted in something.  Capacitors don't 
> really have anything which can "sing".
> 

I have no idea. Previous reports of this behaviour have always been described as "singing" capacitors and explained by some piezoelectric effect.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
