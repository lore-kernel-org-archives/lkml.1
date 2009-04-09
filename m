Return-Path: <linux-kernel-owner+w=401wt.eu-S933706AbZDIMvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933706AbZDIMvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 08:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761775AbZDIMvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 08:51:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38778 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761395AbZDIMvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 08:51:20 -0400
Date: Thu, 9 Apr 2009 13:51:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jean Delvare <khali@linux-fr.org>
Cc: Jack Stone <jwjstone@fastmail.fm>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 13/56] i2c: Remove void casts
Message-ID: <20090409135123.36e6415b@lxorguk.ukuu.org.uk>
In-Reply-To: <20090409144334.4c283ef2@hyperion.delvare>
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-2-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-3-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-4-git-send-email-jwjstone@fastmail.fm>
	<1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>
	<20090409144334.4c283ef2@hyperion.delvare>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Apr 2009 14:43:34 +0200
Jean Delvare <khali@linux-fr.org> wrote:

> Hi Jack,
> 
> On Wed,  8 Apr 2009 12:21:45 +0100, Jack Stone wrote:
> > Remove uneeded void casts
> > 
> > Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> 
> WARNING: Signed-off-by: is the preferred form

Nothing actually cares, and if anyone does then we have software for the
mindless purpose of changing the case of words

Alan
