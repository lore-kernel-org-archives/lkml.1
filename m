Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbYFOG3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbYFOG3s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 02:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbYFOG3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 02:29:41 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:44219 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751766AbYFOG3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 02:29:41 -0400
Message-ID: <4854B6D1.2090706@davidnewall.com>
Date: Sun, 15 Jun 2008 15:59:37 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: werner <werner@sys-linux.yi.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Regressions in the last kernels
References: <1213467969.31034@sys-linux.yi.org>
In-Reply-To: <1213467969.31034@sys-linux.yi.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

werner wrote:
> During preparation and own testing for my distro; installation on computers for neighbours, by reclamations by users, I learned about the following problems of 2.6.26-rcX :
>
> 1) When compiling for i486,  one cannot select/configurate more memory than 4 GB, menuconfig don't show items with higher values.
>   

Is not the i486 limited to a 4GB address space?
