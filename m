Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492Ab0ADPlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab0ADPlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 10:41:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422Ab0ADPlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 10:41:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab0ADPlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 10:41:05 -0500
Message-ID: <4B420C06.3080402@redhat.com>
Date: Mon, 04 Jan 2010 10:40:54 -0500
From: Peter Jones <pjones@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/firmware/iscsi_ibft.c: use %pM to show MAC address
References: <BD79186B4FD85F4B8E60E381CAEE19090200F669@mi8nycmail19.Mi8.com>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200F669@mi8nycmail19.Mi8.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2009 02:49 PM, H Hartley Sweeten wrote:
> Use the %pM kernel extension to display the MAC address.
> 
> Also, remove the 'mac' variable and use nic->mac directly.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Peter Jones <pjones@redhat.com>

Looks good to me.

Acked-by: Peter Jones <pjones@redhat.com>

-- 
        Peter
