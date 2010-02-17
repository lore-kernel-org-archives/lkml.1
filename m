Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491Ab0BQCV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 21:21:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:35355 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933335Ab0BQCV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 21:21:57 -0500
Message-ID: <4B7B548B.4040606@kernel.org>
Date: Wed, 17 Feb 2010 11:29:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Axel Uhl <axel.uhl@gmx.de>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Kernel Bug in ATA or SMART area
References: <4B72941A.7060704@gmx.de> <4B74BDCF.1010805@kernel.org> <4B74F263.1060709@gmx.de> <4B7505CA.60409@kernel.org> <4B75154B.8030507@gmx.de>
In-Reply-To: <4B75154B.8030507@gmx.de>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Feb 2010 02:21:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/12/2010 05:46 PM, Axel Uhl wrote:
> I don't have a /var/log/boot.msg, only a /var/log/boot. Its contents:

Then please attach output of dmesg after boot.

Thanks.

-- 
tejun
