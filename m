Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab0BBOVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 09:21:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:39710 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756052Ab0BBOVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 09:21:35 -0500
Message-ID: <4B683581.7070708@kernel.org>
Date: Tue, 02 Feb 2010 23:24:01 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Chandra Shekhar Sah <edu4madh@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: port multiplier problem
References: <4B5885F7.2020007@gmail.com> <4B679EA9.6030203@kernel.org> <4B6833DD.1020001@gmail.com>
In-Reply-To: <4B6833DD.1020001@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 02 Feb 2010 14:21:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2010 11:17 PM, Chandra Shekhar Sah wrote:
> I thought PMP is damaged so I purchased a new NORCO-LIB1220 backplane
> card but same problem. The disks connected to PMP are not being
> recognized. However, disk connected to "direct sata" (no disks on PMP)
> is fine.

Ah.. okay, can you please post full dmesg of failed probe?

Thanks.

-- 
tejun
