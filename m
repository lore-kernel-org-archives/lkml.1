Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbYAPKaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbYAPKaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 05:30:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYAPKaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 05:30:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48925
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751745AbYAPKaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 05:30:07 -0500
Date: Wed, 16 Jan 2008 02:29:53 -0800 (PST)
Message-Id: <20080116.022953.184520911.davem@davemloft.net>
To: elendil@planet.nl
Cc: jesse.brandeburg@intel.com, slavon@bigtelecom.ru, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] 2.6.24-rc7: e1000: Detected Tx Unit Hang
From: David Miller <davem@davemloft.net>
In-Reply-To: <200801160956.09053.elendil@planet.nl>
References: <36D9DB17C6DE9E40B059440DB8D95F52042FA541@orsmsx418.amr.corp.intel.com>
	<20080115.210214.170759690.davem@davemloft.net>
	<200801160956.09053.elendil@planet.nl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Pop <elendil@planet.nl>
Date: Wed, 16 Jan 2008 09:56:08 +0100

> On Wednesday 16 January 2008, David Miller wrote:
> > Ok, here is the patch I'll propose to fix this.  The goal is to make
> > it as simple as possible without regressing the thing we were trying
> > to fix.
> 
> Looks good to me. Tested with -rc8.

Thanks for testing.
