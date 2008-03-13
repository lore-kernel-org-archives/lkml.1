Return-Path: <linux-kernel-owner+w=401wt.eu-S1757307AbYCMVDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307AbYCMVDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 17:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbYCMVCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 17:02:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50362 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbYCMVCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 17:02:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: 2.6.25-rc5-git2: Reported regressions from 2.6.24
Date: Thu, 13 Mar 2008 22:02:06 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Tino Keitel <tino.keitel@gmx.de>, linux-kernel@vger.kernel.org,
       Lennert Buytenhek <buytenh@wantstofly.org>,
       Linas =?utf-8?q?=C5=BDvirblis?= <0x0007@gmail.com>
References: <200803120141.51844.rjw@sisk.pl> <200803122328.19285.rjw@sisk.pl> <47D8936B.3020501@garzik.org>
In-Reply-To: <47D8936B.3020501@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803132202.07531.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 13 of March 2008, Jeff Garzik wrote:
> 
> The following regression fix is now upstream...
> 
> 
> 
> Commit:     f9e7d100ddea5cdcea7a02230566f36b0a648c2e
> 
>      FIXED_PHY must depend on PHYLIB=y

Thanks, closed.
