Return-Path: <linux-kernel-owner+w=401wt.eu-S1755697AbZCEUPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbZCEUPv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 15:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbZCEUPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 15:15:34 -0500
Received: from gw.goop.org ([64.81.55.164]:54401 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755696AbZCEUPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 15:15:32 -0500
Message-ID: <49B032E1.50303@goop.org>
Date: Thu, 05 Mar 2009 12:15:29 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Hannes Eder <hannes@hanneseder.net>
CC: trivial@kernel.org, xen-devel@lists.xensource.com,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org
Subject: Re: [PATCH v2 03/15] NULL noise: arch/x86/xen/smp.c
References: <20090305190954.30062.44759.stgit@f10box.hanneseder.net> <20090305191350.30062.68789.stgit@f10box.hanneseder.net>
In-Reply-To: <20090305191350.30062.68789.stgit@f10box.hanneseder.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Eder wrote:
> Fix this sparse warnings:
>   arch/x86/xen/smp.c:316:52: warning: Using plain integer as NULL pointer
>   arch/x86/xen/smp.c:421:60: warning: Using plain integer as NULL pointer
>
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
>   
Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

    J
