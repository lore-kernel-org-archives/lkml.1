Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbYBOFXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbYBOFXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 00:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbYBOFWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 00:22:54 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52716 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbYBOFWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 00:22:54 -0500
Message-ID: <47B5214F.1070906@cn.fujitsu.com>
Date: Fri, 15 Feb 2008 13:21:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: sean.hefty@intel.com, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix return value in ib_device_register_sysfs()
References: <47B4F7F1.1090002@cn.fujitsu.com> <adave4qol8l.fsf@cisco.com>
In-Reply-To: <adave4qol8l.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> Wow, good catch.  How did you find this bug?
> 

Just by accident, when I glanced down the code. ;)

> Anyway, thanks, applied.
> 
>  - R.
> 
