Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbXJKKuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbXJKKuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 06:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbXJKKuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 06:50:10 -0400
Received: from main.gmane.org ([80.91.229.2]:36033 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbXJKKuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 06:50:09 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stefan Scheler <stefan@scheler.com>
Subject: Regression from 2.6.21 to 2.6.22 and above
Date: Thu, 11 Oct 2007 12:41:11 +0200
Message-ID: <fekuk7$kpl$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: dslb-088-066-206-166.pools.arcor-ip.net
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

my Kobil KAAN Professional (USB variant) smartcard reader stopped
working when upgrading from 2.6.21 to 2.6.22 (and 2.6.23). Not working
means that the latest libct.so supplied from Kobil is segfaulting when
trying to access the device. But as far as I can see the kobil_sct
driver itself didn't change from 2.6.21 to 2.6.22. Any ideas what is
going on here?

Thanks in advance. I will provide additional information if needed.

-- 
Stefan Scheler

