Return-Path: <linux-kernel-owner+w=401wt.eu-S965119AbXCPO0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965119AbXCPO0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 10:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965155AbXCPO0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 10:26:22 -0400
Received: from bill.weihenstephan.org ([82.135.35.21]:39119 "EHLO
	bill.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965119AbXCPO0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 10:26:21 -0400
X-Greylist: delayed 2018 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Mar 2007 10:26:21 EDT
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: linux-kernel@vger.kernel.org
Subject: kfifo and copy_from/to_user without temporarily buffer?
Date: Fri, 16 Mar 2007 14:52:37 +0100
User-Agent: KMail/1.9.4
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703161452.37516.juergen127@kreuzholzen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

is there a "nice" way to go to use the kfifo feature together with 
copy_from/to_user without a temporarily buffer? I didn't find any example 
yet.

Thanks in advance for any hint.

Juergen
