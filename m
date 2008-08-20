Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbYHTBKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbYHTBKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 21:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYHTBK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 21:10:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:48483 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbYHTBK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 21:10:27 -0400
Date: Tue, 19 Aug 2008 18:07:38 -0700
From: greg@kroah.com
To: Jeff Garzik <jgarzik@pobox.com>
Cc: netdev@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 00/02] 2 more hso.c patches
Message-ID: <20080820010738.GA3365@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,

Here are two more patches for drivers/net/usb/hso.c that fix problems
people have reported.

I know you accepted the previously posted patches for this driver, but
they don't seem to be in Linus's tree yet, are they queued up for
inclusion before 2.6.27 is out?

thanks,

greg k-h
