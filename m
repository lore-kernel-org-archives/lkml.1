Return-Path: <linux-kernel-owner+w=401wt.eu-S1759923AbYFRFZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923AbYFRFZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 01:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbYFRFZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 01:25:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53229
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753534AbYFRFZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 01:25:42 -0400
Date: Tue, 17 Jun 2008 22:25:42 -0700 (PDT)
Message-Id: <20080617.222542.243601098.davem@davemloft.net>
To: yanmin_zhang@linux.intel.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org
Subject: Re: IPF Montvale machine panic when running a network-relevent
 testing
From: David Miller <davem@davemloft.net>
In-Reply-To: <1213765922.25608.36.camel@ymzhang>
References: <1213759663.25608.33.camel@ymzhang>
	<20080617.203703.254889774.davem@davemloft.net>
	<1213765922.25608.36.camel@ymzhang>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Date: Wed, 18 Jun 2008 13:12:02 +0800

> I happened to download git tree on June 16th, which includes the reverting patch.
> 
> I confirm it fixes the hang issue.

Thank you for testing.
