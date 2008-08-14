Return-Path: <linux-kernel-owner+w=401wt.eu-S1759250AbYHNVH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbYHNVH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 17:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753684AbYHNVHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 17:07:21 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:33284 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbYHNVHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 17:07:20 -0400
Message-ID: <48A49C78.7070100@linux.vnet.ibm.com>
Date: Fri, 15 Aug 2008 02:28:32 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm_owner: fix cgroup null dereference
References: <1218745013-9537-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1218745013-9537-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Hi,
> 
> found this in mmotm, a fix for
> mm-owner-fix-race-between-swap-and-exit.patch
> 

Thanks for catching this

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Balbir
