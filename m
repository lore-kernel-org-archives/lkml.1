Return-Path: <linux-kernel-owner+w=401wt.eu-S1760033AbZB0XgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760033AbZB0XgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 18:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZB0XgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 18:36:18 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:59697 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZB0XgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 18:36:17 -0500
Message-ID: <49A878BE.4080308@oracle.com>
Date: Fri, 27 Feb 2009 15:35:26 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm <akpm@linux-foundation.org>, Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: mmotm 2009-02-27-13-54 uploaded (input/misc/twl4030)
References: <200902272212.n1RMClcN007585@imap1.linux-foundation.org>
In-Reply-To: <200902272212.n1RMClcN007585@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.49A878CE.008A:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-02-27-13-54 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git


mmotm-2009-0227-1354/drivers/input/misc/twl4030-pwrbutton.c:107: error: 'TWL4030_PWRIRQ_PWRBTN' undeclared (first use in this function)


~Randy

