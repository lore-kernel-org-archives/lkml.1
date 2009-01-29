Return-Path: <linux-kernel-owner+w=401wt.eu-S1758191AbZA2Xa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191AbZA2Xa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZA2XaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:30:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52672
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751508AbZA2XaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:30:06 -0500
Date: Thu, 29 Jan 2009 15:30:04 -0800 (PST)
Message-Id: <20090129.153004.183284867.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-01-29
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090129212725.GB6085@tuxdriver.com>
References: <20090129212725.GB6085@tuxdriver.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 29 Jan 2009 16:27:25 -0500

> I present to you another round of patches intended for 2.6.29.  There is
> a MAINTAINERS patch that recognizes the reality that Michael Wu is no
> longer touching mac80211.  There is a power setting patch for rtl8187
> that corrects a functional regression, and a NULL pointer fix for
> iwlagn.  There are a couple of regulatory-related patches that are
> isolated and I think merit inclusion based on their nature.  Finally,
> there is an ath5k fix for an older problem that is more prevalent since
> the merge of "ath5k: ignore the return value of
> ath5k_hw_noise_floor_calibration" and which addresses kernel.org bugs
> 12068 and 12080.

Pulled, thanks a lot John.
