Return-Path: <linux-kernel-owner+w=401wt.eu-S1752584AbYH1Iuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbYH1Iuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 04:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbYH1Iun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 04:50:43 -0400
Received: from relay2.globalproof.net ([194.146.153.25]:37800 "EHLO
	relay2.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbYH1Ium (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 04:50:42 -0400
From: Denys Fedoryshchenko <denys@visp.net.lb>
Organization: Virtual ISP
To: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: loaded router, excessive getnstimeofday in oprofile
Date: Thu, 28 Aug 2008 11:49:14 +0300
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200808220457.40892.denys@visp.net.lb> <20080827203518.7f6075a0@extreme>
In-Reply-To: <20080827203518.7f6075a0@extreme>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808281149.14502.denys@visp.net.lb>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 August 2008, Stephen Hemminger wrote:
>
> What kernel version is this?  There was a fix to AF_PACKET about a year ago
> to reduce this.
> --
git net-2.6 based on 2.6.27-rc3. Means very fresh.

