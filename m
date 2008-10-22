Return-Path: <linux-kernel-owner+w=401wt.eu-S1752964AbYJVAaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbYJVAaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 20:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYJVAar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 20:30:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:54209 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbYJVAaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 20:30:46 -0400
Subject: Re: [PATCH 2/7] i2c: add info->archdata field
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jean Delvare <khali@linux-fr.org>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       i2c@lm-sensors.org, David Miller <davem@davemloft.net>
In-Reply-To: <20081017112125.1f2c9d94@hyperion.delvare>
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru>
	 <20081016171253.GB5515@oksana.dev.rtsoft.ru>
	 <20081017112125.1f2c9d94@hyperion.delvare>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 11:27:34 +1100
Message-Id: <1224635254.7654.292.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-17 at 11:21 +0200, Jean Delvare wrote:
> Hi Anton,
> 
> On Thu, 16 Oct 2008 21:12:53 +0400, Anton Vorontsov wrote:
> > If present the info->archdata is copied into the dev->archdata.
> > Some (OpenFirmware) platforms need it.
> > 
> > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> > ---

So who's pushing this one ? Jean ?

Cheers,
Ben.

