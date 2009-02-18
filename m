Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbZBRUBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbZBRUBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 15:01:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbZBRUA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 15:00:58 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:42207 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbZBRUA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 15:00:58 -0500
Date: Wed, 18 Feb 2009 21:00:55 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Rabin Vincent <rabin@rab.in>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc_test: fix basic read test
Message-ID: <20090218210055.6dc3401e@mjolnir.ossman.eu>
In-Reply-To: <20090213172526.GA1807@debian>
References: <20090213172526.GA1807@debian>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Feb 2009 22:55:26 +0530
Rabin Vincent <rabin@rab.in> wrote:

> Due to a typo in the Basic Read test, it's currently identical to the
> Basic Write test.  Fix this.
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---

Ooops. Queued. :)

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
