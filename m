Return-Path: <linux-kernel-owner+w=401wt.eu-S1759182AbYAKOFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182AbYAKOFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 09:05:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759569AbYAKOFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 09:05:19 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:41082 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759369AbYAKOFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 09:05:18 -0500
Message-ID: <4787779B.1070100@davidnewall.com>
Date: Sat, 12 Jan 2008 00:35:15 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: righiandr@users.sourceforge.net
CC: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC][PATCH] per-task I/O throttling
References: <47869FFE.1050000@users.sourceforge.net>
In-Reply-To: <47869FFE.1050000@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Righi wrote:
> [I/O-intensive] processes can noticeably impact the system responsiveness
> for some time and playing with tasks' priority is not always an
> acceptable solution.
>   

Why?
