Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbXL2B3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbXL2B3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 20:29:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbXL2B3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 20:29:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42549 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbXL2B3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 20:29:05 -0500
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <20071229010157.GB2883@darkstar.te-china.tietoenator.com>
References: <20071229010157.GB2883@darkstar.te-china.tietoenator.com>
Content-Type: text/plain
Date: Sat, 29 Dec 2007 02:29:02 +0100
Message-Id: <1198891742.6821.98.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



I'm pretty sure you didn't boot that kernel with lockdep enabled.

Also, most, if not all, of your patches miss a patch description.

