Return-Path: <linux-kernel-owner+w=401wt.eu-S1161010AbXDLFk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161010AbXDLFk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 01:40:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161560AbXDLFk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 01:40:59 -0400
Received: from server2.meudns3.com ([74.52.31.50]:27182 "EHLO
	server2.meudns3.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161010AbXDLFk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 01:40:59 -0400
From: Pedro <linux_user@izecksohn.com>
To: Al Boldi <a1426z@gawab.com>
Subject: Re: tmpfs and the OOM killer
Date: Thu, 12 Apr 2007 02:39:43 -0300
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200704120804.34551.a1426z@gawab.com>
In-Reply-To: <200704120804.34551.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704120239.43575.linux_user@izecksohn.com>
X-PopBeforeSMTPSenders: linux_user@izecksohn.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server2.meudns3.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - izecksohn.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 April 2007 02:04, Al Boldi wrote:
> > Pedro wrote:
> >   2) How should an application be written to not be killed by OOM?
>
> Try this:
>
> # echo -17 > /proc/<pid>/oom_adj

  I should know that to run a fail-safe application is a superuser privilege.

  Sorry from wasting your time.
