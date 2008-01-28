Return-Path: <linux-kernel-owner+w=401wt.eu-S1759851AbYA1JoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759851AbYA1JoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 04:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750776AbYA1Jnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 04:43:52 -0500
Received: from smtp-101-monday.noc.nerim.net ([62.4.17.101]:1513 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751104AbYA1Jnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:43:51 -0500
Date: Mon, 28 Jan 2008 10:43:48 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Jon Smirl" <jonsmirl@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux I2C" <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] i2c updates for 2.6.25
Message-ID: <20080128104348.0f6925f6@hyperion.delvare>
In-Reply-To: <9e4733910801270936q7affdee3o3518c2265acaf61d@mail.gmail.com>
References: <20080127182741.62bfe92a@hyperion.delvare>
	<9e4733910801270936q7affdee3o3518c2265acaf61d@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

On Sun, 27 Jan 2008 12:36:03 -0500, Jon Smirl wrote:
> On 1/27/08, Jean Delvare <khali@linux-fr.org> wrote:
> > Linus,
> >
> > Please pull the i2c subsystem updates for Linux 2.6.25 from:
> >
> > git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus
> 
> The support for modalias loading of i2c modules isn't in here, what's
> the status?

The status is that I want to give people some time to comment on my
modalias patches before I merge them. I also didn't have the time to
look into the latest patches you sent yet, and I'd rather merge
everything at once. So the merge window for this is rather 2.6.26.

-- 
Jean Delvare
