Return-Path: <linux-kernel-owner+w=401wt.eu-S1753163AbXKJOeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbXKJOeG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 09:34:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbXKJOd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 09:33:56 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:44099 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250AbXKJOdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 09:33:55 -0500
Date: Sat, 10 Nov 2007 15:33:50 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: remove CONFIG_EXPERIMENTAL
Message-ID: <20071110153350.632a7807@poseidon.drzeus.cx>
In-Reply-To: <20071101050855.GY7227@stusta.de>
References: <20071101050855.GY7227@stusta.de>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007 06:08:55 +0100
Adrian Bunk <bunk@kernel.org> wrote:

> - History has shown that often the dependency on EXPERIMENTAL is not 
>   removed when the code has proven usable.

Guilty as charged. Feel free to kill any references to experimental for sdhci.

(I also support the general sentiment)

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
