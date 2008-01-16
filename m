Return-Path: <linux-kernel-owner+w=401wt.eu-S1752592AbYAPI4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbYAPI4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 03:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYAPI4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 03:56:13 -0500
Received: from hpsmtp-eml15.KPNXCHANGE.COM ([213.75.38.115]:17882 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308AbYAPI4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 03:56:12 -0500
From: Frans Pop <elendil@planet.nl>
To: David Miller <davem@davemloft.net>
Subject: Re: [REGRESSION] 2.6.24-rc7: e1000: Detected Tx Unit Hang
Date: Wed, 16 Jan 2008 09:56:08 +0100
User-Agent: KMail/1.9.7
Cc: jesse.brandeburg@intel.com, slavon@bigtelecom.ru, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200801151504.10047.elendil@planet.nl> <36D9DB17C6DE9E40B059440DB8D95F52042FA541@orsmsx418.amr.corp.intel.com> <20080115.210214.170759690.davem@davemloft.net>
In-Reply-To: <20080115.210214.170759690.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801160956.09053.elendil@planet.nl>
X-OriginalArrivalTime: 16 Jan 2008 08:56:09.0647 (UTC) FILETIME=[A34393F0:01C8581D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 January 2008, David Miller wrote:
> Ok, here is the patch I'll propose to fix this.  The goal is to make
> it as simple as possible without regressing the thing we were trying
> to fix.

Looks good to me. Tested with -rc8.

Cheers,
FJP
