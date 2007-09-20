Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbXITSJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbXITSJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 14:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756882AbXITSJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 14:09:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225AbXITSJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 14:09:16 -0400
Message-ID: <46F2B746.2070409@redhat.com>
Date: Thu, 20 Sep 2007 14:09:10 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Frank Mayhar <fmayhar@google.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH getrusage: return ru_maxrss
References: <1190311039.13070.19.camel@peace.smo.corp.google.com>
In-Reply-To: <1190311039.13070.19.camel@peace.smo.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Mayhar wrote:
> Properly support the ru_maxrss field of the rusage structure returned by
> getrusage(). 

> Signed-off-by:  Frank Mayhar <fmayhar@google.com>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All Rights Reversed
