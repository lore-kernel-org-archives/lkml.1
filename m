Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbYJNV0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbYJNV0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 17:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbYJNVZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 17:25:59 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:15241 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbYJNVZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 17:25:59 -0400
Date: Tue, 14 Oct 2008 23:25:36 +0200
From: Jean Delvare <khali@linux-fr.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, i2c@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] i2c updates for 2.6.28, round 1
Message-ID: <20081014232536.716f149d@hyperion.delvare>
In-Reply-To: <20081014.131331.115267742.davem@davemloft.net>
References: <20081014180333.55d9004a@hyperion.delvare>
	<20081014.114609.74110219.davem@davemloft.net>
	<20081014215137.2d039afb@hyperion.delvare>
	<20081014.131331.115267742.davem@davemloft.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Tue, 14 Oct 2008 13:13:31 -0700 (PDT), David Miller wrote:
> From: Jean Delvare <khali@linux-fr.org>
> Date: Tue, 14 Oct 2008 21:51:37 +0200
> 
> > Except for one i2c-i801 patch which depends on a pci_ids update, all I
> > have in my queue was part of this pull request. So, no, I don't have
> > your bus addressing nor sparc I2C driver bits. Honestly, I can't even
> > remember getting such patches from you. Do you have some reference I
> > can search for? If not, please send the patches to the i2c list again.
> 
> Here are URLs to the I2C list patch postings I made, you were CC:'d on
> every single one of them:
> 
> http://lists.lm-sensors.org/pipermail/i2c/2008-August/004714.html
> http://lists.lm-sensors.org/pipermail/i2c/2008-August/004716.html
> http://lists.lm-sensors.org/pipermail/i2c/2008-August/004717.html
> http://lists.lm-sensors.org/pipermail/i2c/2008-August/004713.html
> http://lists.lm-sensors.org/pipermail/i2c/2008-August/004715.html
> http://lists.lm-sensors.org/pipermail/i2c/2008-August/004719.html
> http://lists.lm-sensors.org/pipermail/i2c/2008-August/004718.html
> 
> And I include each posting here as an attachment as well.

Ah, these patches. Yes, they are in my inbox. No, I didn't have the
time to review them when you posted them, sorry, and then I forgot
about them.

> Please apply.

Well, I can't apply them without giving them at least a quick review.
I'll try to do that in the next few days so that the patches can be
part of my second i2c pull request to Linus for 2.6.28. That is, if I
don't see anything that needs more discussions.

-- 
Jean Delvare
