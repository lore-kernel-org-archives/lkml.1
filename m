Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbXI1L21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbXI1L21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 07:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbXI1L2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 07:28:20 -0400
Received: from mailout3.imos.net ([212.87.132.34]:1236 "EHLO mailout3.imos.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbXI1L2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 07:28:19 -0400
X-Greylist: delayed 8332 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Sep 2007 07:28:18 EDT
Message-ID: <46FCC3E4.7030908@theendofthetunnel.de>
Date: Fri, 28 Sep 2007 11:05:40 +0200
From: Hannes Dorbath <light@theendofthetunnel.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.6) Gecko/20070728 Thunderbird/2.0.0.6 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Laurent CARON <lcaron@lncsa.com>
CC: linux-kernel@vger.kernel.org, drbd-user@linbit.com
Subject: Re: [DRBD-user] Crash on 2.6.22
References: <46FCC2BE.7020509@lncsa.com>
In-Reply-To: <46FCC2BE.7020509@lncsa.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.09.2007 11:00, Laurent CARON wrote:
> The $HOME directories are stored on a drbd (version: 0.7.24
> (api:79/proto:74)) partition (with an XFS filesystem).

Was the deadlock with 2.6.22 only in 0.8.x? Is 0.7.x fine with 2.6.22?


-- 
Regards,
Hannes Dorbath
