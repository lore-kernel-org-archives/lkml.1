Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbYJBPeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbYJBPeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 11:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYJBPeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 11:34:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60458 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbYJBPeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 11:34:01 -0400
Message-ID: <48E4E805.2030201@zytor.com>
Date: Thu, 02 Oct 2008 08:25:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rodolfo Giometti <giometti@linux.it>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 05/10] ldisc: new dcd_change() method for line disciplines.
References: <> <1222933309-2524-1-git-send-email-giometti@linux.it> <1222933309-2524-2-git-send-email-giometti@linux.it> <1222933309-2524-3-git-send-email-giometti@linux.it> <1222933309-2524-4-git-send-email-giometti@linux.it> <1222933309-2524-5-git-send-email-giometti@linux.it> <1222933309-2524-6-git-send-email-giometti@linux.it>
In-Reply-To: <1222933309-2524-6-git-send-email-giometti@linux.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why limit this to just DCD change, and not any of the other status bits 
(DCD, RI, DSR, CTS)?

	-hpa
