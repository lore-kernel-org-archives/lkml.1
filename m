Return-Path: <linux-kernel-owner+w=401wt.eu-S1751876AbXCHOJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbXCHOJD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 09:09:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbXCHOJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 09:09:03 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:10614 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbXCHOJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 09:09:02 -0500
Date: Thu, 8 Mar 2007 15:08:24 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: kernel@kolivas.org
Cc: linux-kernel@vger.kernel.org
Subject: RSDL test
Message-ID: <20070308140822.GA3392@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Con,

One thing that has annoyed me greatly lately, is that scrolling in
firefox very quickly becomes a huge pain if you have any load on your
box. I typically do make -j4 kernel builds on my laptop (core duo), and
try to stay out of firefox for that period simply because it's not very
responsive (to the point of being really annoying). A pseudo test of
running two

$ while true; do a=1; done

produces the same result, firefox is unusable.

So seeing your post, I gave it a spin. Works great for me, much better
than the stock 2.6.21-rc3 wrt interactive feel. I know this is a
subjective test, but believe me, there's a world of difference.

-- 
Jens Axboe

