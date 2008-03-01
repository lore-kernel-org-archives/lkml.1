Return-Path: <linux-kernel-owner+w=401wt.eu-S1757749AbYCAMad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbYCAMad (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 07:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbYCAMa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 07:30:26 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:46980 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbYCAMa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 07:30:26 -0500
Date: Sat, 1 Mar 2008 13:29:24 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080301132924.0dc22b36@mjolnir.drzeus.cx>
In-Reply-To: <493b45a1-bb40-4e3c-9a8e-4b6ee7b8fdc3@b1g2000hsg.googlegroups.com>
References: <a2itf-5jB-27@gated-at.bofh.it>
	<493b45a1-bb40-4e3c-9a8e-4b6ee7b8fdc3@b1g2000hsg.googlegroups.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 13:09:05 -0800 (PST)
Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:

> Pierre Ossman wrote:
> > Many devices today are of a less than stellar quality, and singing
> > transistors are a common problem. A high-pitch noise is created, caused
> > by power fluctuations as the processor enters and leaves deep sleep at
> > a high frequency.
> 
> Capacitors or transistors?  The subject and the description disagree.
> 

That should teach me to write commit messages when I'm tired... Capacitors is of course the right answer. :)

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
