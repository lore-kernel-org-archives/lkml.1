Return-Path: <linux-kernel-owner+w=401wt.eu-S1757352AbZJSTds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352AbZJSTds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 15:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757254AbZJSTdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 15:33:47 -0400
Received: from poutre.nerim.net ([62.4.16.124]:62052 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757250AbZJSTdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 15:33:47 -0400
Date: Mon, 19 Oct 2009 21:33:48 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Amit Kucheria <amit.kucheria@verdurent.com>,
       List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH 3/5] mfd: twl4030-power: Move power-related data closer
  together in the header file
Message-ID: <20091019213348.28e93f29@hyperion.delvare>
In-Reply-To: <20091019191232.GA30203@sortiz.org>
References: <1255954211-28496-1-git-send-email-amit.kucheria@verdurent.com>
	<1255954252-29017-1-git-send-email-amit.kucheria@verdurent.com>
	<20091019191232.GA30203@sortiz.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Oct 2009 21:12:33 +0200, Samuel Ortiz wrote:
> Hi Amit,
> 
> On Mon, Oct 19, 2009 at 03:10:52PM +0300, Amit Kucheria wrote:
> > Bring together all the TWL power-related data in the header file
> I dont really see the point of doing this, as you're not really gathering
> scattered structures but rather moving a group of definitions up in the header
> file.
> If you dont mind I'll drop this one, unless Jean wants to take it.

No, I don't care about this at all ;)

-- 
Jean Delvare
