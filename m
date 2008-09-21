Return-Path: <linux-kernel-owner+w=401wt.eu-S1753779AbYIUWmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbYIUWmd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 18:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYIUWmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 18:42:24 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41331 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbYIUWmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 18:42:23 -0400
Date: Sun, 21 Sep 2008 23:42:10 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       ipw2100-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       yi.zhu@intel.com, reinette.chatre@intel.com, jgarzik@pobox.com,
       linville@tuxdriver.com, davem@davemloft.net
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware restart.
Message-ID: <20080921224210.GA24461@srcf.ucam.org>
References: <20080921172316.GA6306@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080921172316.GA6306@2ka.mipt.ru>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try D3ing the chip in the firmware restart code. Yes, it's retarded.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
