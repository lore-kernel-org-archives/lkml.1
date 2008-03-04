Return-Path: <linux-kernel-owner+w=401wt.eu-S1759773AbYCDEyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773AbYCDEyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 23:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbYCDEyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 23:54:46 -0500
Received: from ozlabs.org ([203.10.76.45]:53371 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbYCDEyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 23:54:46 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: parag.warudkar@gmail.com
Subject: Re: 2.6.25-rc1: Lguest build failure
Date: Tue, 4 Mar 2008 15:54:00 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
References: <alpine.LRH.1.00.0802110111270.21195@mini.warudkars.net>
In-Reply-To: <alpine.LRH.1.00.0802110111270.21195@mini.warudkars.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200803041554.00765.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2008 17:15:33 Parag Warudkar wrote:
> Hi Rusty
>
> Just got this build failure while building -rc1 -

Thanks Parag, I've confirmed this is fixed in current Linus tree (with your 
exact config).

Cheers,
Rusty.
