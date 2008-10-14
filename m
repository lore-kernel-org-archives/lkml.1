Return-Path: <linux-kernel-owner+w=401wt.eu-S1754380AbYJNTwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbYJNTwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 15:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbYJNTv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 15:51:58 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:43330 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbYJNTv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 15:51:57 -0400
Date: Tue, 14 Oct 2008 21:51:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] i2c updates for 2.6.28, round 1
Message-ID: <20081014215137.2d039afb@hyperion.delvare>
In-Reply-To: <20081014.114609.74110219.davem@davemloft.net>
References: <20081014180333.55d9004a@hyperion.delvare>
	<20081014.114609.74110219.davem@davemloft.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Tue, 14 Oct 2008 11:46:09 -0700 (PDT), David Miller wrote:
> From: Jean Delvare <khali@linux-fr.org>
> Date: Tue, 14 Oct 2008 18:03:33 +0200
> 
> > Please pull the first round of i2c subsystem updates for Linux 2.6.28
> > from:
> > 
> > git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus
> 
> Jean, do you have my bus addressing and sparc I2C driver bits
> in your queue that I submitted months ago?

Except for one i2c-i801 patch which depends on a pci_ids update, all I
have in my queue was part of this pull request. So, no, I don't have
your bus addressing nor sparc I2C driver bits. Honestly, I can't even
remember getting such patches from you. Do you have some reference I
can search for? If not, please send the patches to the i2c list again.

-- 
Jean Delvare
