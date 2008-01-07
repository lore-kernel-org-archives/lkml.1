Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbYAGF4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbYAGF4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 00:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbYAGF4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 00:56:04 -0500
Received: from mail.gmx.net ([213.165.64.20]:50973 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751734AbYAGF4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 00:56:02 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18oPbMAj2couZQeeDCPRN6o6xwuBHePbxuTNG4tkf
	4f7ABNo9O32LqC
Subject: Re: [vm] writing to UDF DVD+RW (/dev/sr0) while under memory
	pressure: box ==> doorstop
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1199683988.3718.49.camel@homer.simson.net>
References: <1199447212.4529.13.camel@homer.simson.net>
	 <1199612533.4384.54.camel@homer.simson.net>
	 <1199642470.3927.12.camel@homer.simson.net>
	 <20080106122954.d8f04c98.akpm@linux-foundation.org>
	 <1199683988.3718.49.camel@homer.simson.net>
Content-Type: text/plain
Date: Mon, 07 Jan 2008 06:55:58 +0100
Message-Id: <1199685358.3718.50.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> [ 1687.358730]  [<b01a0cd3>] sys_sync+0xa/0x17

duh.

