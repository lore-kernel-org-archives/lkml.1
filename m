Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbYIEDoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbYIEDoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 23:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbYIEDoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 23:44:00 -0400
Received: from 1wt.eu ([62.212.114.60]:3188 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbYIEDn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 23:43:59 -0400
Date: Fri, 5 Sep 2008 05:43:52 +0200
From: Willy Tarreau <w@1wt.eu>
To: ivaylo@bglans.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: ICH9 AHCI support on 2.4.XX
Message-ID: <20080905034352.GA17104@1wt.eu>
References: <Pine.LNX.4.62.0708102357470.24424@mail.bglans.net> <Pine.LNX.4.64.0809042051030.10716@mail.bglans.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0809042051030.10716@mail.bglans.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ivaylo,

On Thu, Sep 04, 2008 at 09:07:49PM +0300, ivaylo@bglans.net wrote:
> 
> Hello,
> 
> I Have Intel motherboard model DG33BU. It is with G33 chipset. There 
> is, Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 6 port SATA AHCI 
> Controller,
> on it. So I make small patch to support this controler in kernel (see 
> bellow or the attached file). Probably it will work and on the 
> other mobos with same chipset.

Thanks for this update. I have already got it (and queued for .37-rc1).
I've not published it yet because I wanted to perform a few preliminary
tests, as I too have the same controller but did not have any SATA disk.

Thanks!
Willy

