Return-Path: <linux-kernel-owner+w=401wt.eu-S934771AbZDIOw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934771AbZDIOw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934628AbZDIOwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:52:38 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:21641 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934676AbZDIOwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:52:37 -0400
Date: Thu, 9 Apr 2009 16:52:26 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jack Stone <jwjstone@fastmail.fm>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 13/56] i2c: Remove void casts
Message-ID: <20090409165226.4801ea60@hyperion.delvare>
In-Reply-To: <20090409135123.36e6415b@lxorguk.ukuu.org.uk>
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
	<20090409144334.4c283ef2@hyperion.delvare>
	<20090409135123.36e6415b@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alan,

On Thu, 9 Apr 2009 13:51:23 +0100, Alan Cox wrote:
> On Thu, 9 Apr 2009 14:43:34 +0200
> Jean Delvare <khali@linux-fr.org> wrote:
> 
> > Hi Jack,
> > 
> > On Wed,  8 Apr 2009 12:21:45 +0100, Jack Stone wrote:
> > > Remove uneeded void casts
> > > 
> > > Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> > 
> > WARNING: Signed-off-by: is the preferred form
> 
> Nothing actually cares, and if anyone does then we have software for the
> mindless purpose of changing the case of words

scripts/checkpatch.pl does care, so I do too.

Thanks,
-- 
Jean Delvare
