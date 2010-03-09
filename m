Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab0CIKtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 05:49:11 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:39174 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab0CIKtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 05:49:09 -0500
Date: Tue, 9 Mar 2010 19:48:22 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH] mfd: Fix sm501 requested region size
Message-ID: <20100309104821.GC8287@linux-sh.org>
References: <20100309080952.GA16041@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100309080952.GA16041@sortiz.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 09:09:54AM +0100, Samuel Ortiz wrote:
> 
> We should only request for the MFD used region, not the whole thing.
> 
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

Works for me, thanks.

Tested-by: Paul Mundt <lethal@linux-sh.org>
