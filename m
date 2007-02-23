Return-Path: <linux-kernel-owner+w=401wt.eu-S933298AbXBXAzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933298AbXBXAzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 19:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933301AbXBXAzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 19:55:14 -0500
Received: from main.gmane.org ([80.91.229.2]:46324 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933298AbXBXAzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 19:55:12 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Mark Gray <mvg001@markvgray.com>
Subject: Re: I2O block driver broken in kernel 2.6.19?
Date: Fri, 23 Feb 2007 22:57:27 +0000 (UTC)
Message-ID: <loom.20070223T235432-923@post.gmane.org>
References: <45D8E102.6090004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 84.92.212.135 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.0.9) Gecko/20061206 Firefox/1.5.0.9)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  i2o/hda:<3>Buffer I/O error on device i2o/hda, logical block 0
> Buffer I/O error on device i2o/hda, logical block 0

Same error here. Both 2.6.19 and 2.6.20 kernels, using Adaptec 2400A RAID.

