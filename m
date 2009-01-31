Return-Path: <linux-kernel-owner+w=401wt.eu-S1753460AbZAaMXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbZAaMXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 07:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZAaMXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 07:23:03 -0500
Received: from senator.holtmann.net ([87.106.208.187]:52337 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbZAaMXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 07:23:01 -0500
Subject: Re: [PATCH] bluetooth: CONFIG_DEBUG_LOCK_ALLOC ifdefs remove
From: Marcel Holtmann <marcel@holtmann.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       davem@davemloft.net
In-Reply-To: <4983E6D3.6010409@gmail.com>
References: <4983E6D3.6010409@gmail.com>
Content-Type: text/plain
Date: Sat, 31 Jan 2009 13:23:10 +0100
Message-Id: <1233404590.4727.0.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> Due to lockdep changes the CONFIG_DEBUG_LOCK_ALLOC ifdef is not needed now, just remove it here.
> 
> The following commit fixed the !lockdep build warnings:
> 
> commit e8f6fbf62de37cbc2e179176ac7010d5f4396b67
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Wed Nov 12 01:38:36 2008 +0000
> 
>     lockdep: include/linux/lockdep.h - fix warning in net/bluetooth/af_bluetooth.c
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

I push this one via my tree to Dave. Thanks.

Regards

Marcel


