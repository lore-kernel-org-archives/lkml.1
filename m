Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbYACWlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbYACWlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 17:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYACWlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 17:41:44 -0500
Received: from 87-194-8-8.bethere.co.uk ([87.194.8.8]:53367 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753450AbYACWln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 17:41:43 -0500
Date: Thu, 3 Jan 2008 22:41:40 +0000
From: Ben Dooks <ben@fluff.org>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Rework arch specific Makefiles to use mkubootimg
Message-ID: <20080103224139.GA4178@fluff.org.uk>
References: <20080103160104.171f9aaa@zod.rchland.ibm.com> <20080103160406.7ef5ecfe@zod.rchland.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103160406.7ef5ecfe@zod.rchland.ibm.com>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 04:04:06PM -0600, Josh Boyer wrote:
> Rework the architecture specific Makefiles to use the in-kernel version of
> the mkubootimg tool.
> 
> Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>

A CC: to RMK and any other arch maintainers being touched by this
would have useful too.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
