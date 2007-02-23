Return-Path: <linux-kernel-owner+w=401wt.eu-S932949AbXBWQFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949AbXBWQFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 11:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933114AbXBWQFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 11:05:20 -0500
Received: from mxout-03.mxes.net ([216.86.168.178]:1300 "EHLO
	mxout-03.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932949AbXBWQFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 11:05:17 -0500
Subject: Re: 2.6.21-rc1: framebuffer/console boot failure
From: Andrew <andrew@nelless.net>
To: linux-kernel@vger.kernel.org
In-Reply-To: <35472.86.7.220.119.1172237750.squirrel@wmbeta.mxes.net>
References: <35472.86.7.220.119.1172237750.squirrel@wmbeta.mxes.net>
Content-Type: text/plain
Date: Fri, 23 Feb 2007 16:05:19 +0000
Message-Id: <1172246719.3249.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have just discovered 2.6.21-rc1 boots with
pci=noacpi ...

