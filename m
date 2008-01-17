Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbYAQHwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbYAQHwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 02:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbYAQHv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 02:51:59 -0500
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:41713 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751132AbYAQHv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 02:51:58 -0500
From: Frans Pop <elendil@planet.nl>
To: David Miller <davem@davemloft.net>
Subject: Re: [REGRESSION] 2.6.24-rc7: e1000: Detected Tx Unit Hang
Date: Thu, 17 Jan 2008 08:51:55 +0100
User-Agent: KMail/1.9.7
Cc: jesse.brandeburg@intel.com, slavon@bigtelecom.ru, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <36D9DB17C6DE9E40B059440DB8D95F52042FA541@orsmsx418.amr.corp.intel.com> <36D9DB17C6DE9E40B059440DB8D95F520432DA91@orsmsx418.amr.corp.intel.com> <20080116.232037.261622584.davem@davemloft.net>
In-Reply-To: <20080116.232037.261622584.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801170851.56029.elendil@planet.nl>
X-OriginalArrivalTime: 17 Jan 2008 07:51:56.0405 (UTC) FILETIME=[D4F74250:01C858DD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 January 2008, David Miller wrote:
> From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
>
> > We spent Wednesday trying to reproduce (without the patch) these issues
> > without much luck, and have applied the patch cleanly and will continue
> > testing it.  Given the simplicity of the changes, and the community
> > testing, I'll give my ack and we will continue testing.
>
> You need a slow CPU, and you need to make sure you do actually
> trigger the TX limiting code there.

Hmmm. Is a dual core Pentium D 3.20GHz considered slow these days?
