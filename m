Return-Path: <linux-kernel-owner+w=401wt.eu-S1757107AbYEPXiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107AbYEPXiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 19:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbYEPXhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 19:37:55 -0400
Received: from mail.windriver.com ([147.11.1.11]:63721 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbYEPXhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 19:37:54 -0400
Message-ID: <482E1B20.7050400@windriver.com>
Date: Fri, 16 May 2008 19:39:12 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: gianfar build failure.
References: <20080516232920.GA26131@redhat.com>
In-Reply-To: <20080516232920.GA26131@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 May 2008 23:37:33.0035 (UTC) FILETIME=[D033F3B0:01C8B7AD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> Hi Paul,
>  Since your commit d0313587547092af7f5ee8a576793e1e5d61be89
> I see this build failure:
>
> "get_phy_id" [drivers/net/gianfar_driver.ko] undefined!
>
> both CONFIG_PHYLIB and CONFIG_GIANFAR are =m
>
> Missing exports ?
>
> 	Dave
>   

Thanks Dave -- I'll look into it and get a fix out.

Paul.


