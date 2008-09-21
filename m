Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbYIUXqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbYIUXqp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 19:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYIUXqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 19:46:34 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:54792 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbYIUXqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 19:46:33 -0400
Date: Mon, 22 Sep 2008 03:45:32 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       ipw2100-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org,
       yi.zhu@intel.com, reinette.chatre@intel.com, jgarzik@pobox.com,
       linville@tuxdriver.com, davem@davemloft.net
Subject: Re: Mark IPW2100 as BROKEN: Fatal interrupt. Scheduling firmware restart.
Message-ID: <20080921234531.GB17946@2ka.mipt.ru>
References: <20080921172316.GA6306@2ka.mipt.ru> <20080921224210.GA24461@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080921224210.GA24461@srcf.ucam.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2008 at 11:42:10PM +0100, Matthew Garrett (mjg59@srcf.ucam.org) wrote:
> Try D3ing the chip in the firmware restart code. Yes, it's retarded.

Thank you, I will start tests tomorrow.

-- 
	Evgeniy Polyakov
