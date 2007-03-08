Return-Path: <linux-kernel-owner+w=401wt.eu-S1752206AbXCHPro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbXCHPro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 10:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbXCHPro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 10:47:44 -0500
Received: from vsmtp14.tin.it ([212.216.176.118]:37289 "EHLO vsmtp14.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbXCHPrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 10:47:43 -0500
Subject: Re: Problem with libata-pata, ATAPI DVD reader and a
	"copy-protected" audio cd
From: GhePeU <ghepeu@virgilio.it>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1173360956.24659.3.camel@KazeNoTani>
References: <1172919624.23576.31.camel@KazeNoTani>
	 <1173360956.24659.3.camel@KazeNoTani>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 16:47:40 +0100
Message-Id: <1173368860.24659.7.camel@KazeNoTani>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il giorno gio, 08/03/2007 alle 14.35 +0100, GhePeU ha scritto:
> > 
> 
> Well, it happened again, with a different cd, and this time I never
> started the player: hal/g-v-m tried to access the CD and now my driver
> is in PIO2 mode and pretty much unusable. Is there a way to fix this
> without rebooting?
> 
> Giacomo

I examined this cd and it is not "copy-protected". It is an "Enhanced
CD" and it works without issues with another os or with Linux with the
old "ide" driver.

Giacomo

