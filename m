Return-Path: <linux-kernel-owner+w=401wt.eu-S1759311AbYAYSNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311AbYAYSNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 13:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbYAYSNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 13:13:36 -0500
Received: from az33egw01.freescale.net ([192.88.158.102]:49438 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbYAYSNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 13:13:35 -0500
Message-ID: <479A26C0.7010704@freescale.com>
Date: Fri, 25 Jan 2008 12:13:20 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Aggrwal Poonam <Poonam.Aggrwal@freescale.com>
CC: Gala Kumar <kumar.gala@freescale.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       rubini@vision.unipv.it, linuxppc-dev@ozlabs.org,
       Barkowski Michael <Michael.Barkowski@freescale.com>,
       Cutler Richard <Rich.Cutler@freescale.com>,
       Tabi Timur <timur@freescale.com>,
       Kalra Ashish <ashish.kalra@freescale.com>
Subject: Re: [PATCH UCC TDM 3/3 ] Modified Documentation to explain dtsentries
 for TDM driver
References: <FBA61160C48B8D438F3323FEFB4EF2C279AFF5@zin33exm24.fsl.freescale.net>
In-Reply-To: <FBA61160C48B8D438F3323FEFB4EF2C279AFF5@zin33exm24.fsl.freescale.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aggrwal Poonam wrote:
> The device tree already has a brg-frequency  property in qe node which
> is the value of BRGCLK. 

Yes, I'm saying it belongs as brg/clock-frequency. :-)
CPM1/2 already do this.

-Scott
