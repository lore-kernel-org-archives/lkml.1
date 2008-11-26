Return-Path: <linux-kernel-owner+w=401wt.eu-S1752493AbYKZFsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbYKZFsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 00:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYKZFsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 00:48:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54981
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751167AbYKZFsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 00:48:08 -0500
Date: Tue, 25 Nov 2008 21:48:08 -0800 (PST)
Message-Id: <20081125.214808.208354000.davem@davemloft.net>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 01/24] perfmon: generic headers
From: David Miller <davem@davemloft.net>
In-Reply-To: <492c6fbc.08b6660a.15da.45d1@mx.google.com>
References: <492c6fbc.08b6660a.15da.45d1@mx.google.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: eranian@googlemail.com
Date: Tue, 25 Nov 2008 13:35:56 -0800 (PST)

> This patch adds the generic perfmon headers including the public
> head perfmon.h which can be used by applications. The other
> headers are for kernel use only.
> 
> Signed-off-by: Stephane Eranian <eranian@gmail.com>
 ...
> +/*
> + * system adminstrator configuration controls available via
> + * the /sys/kerne/perfmon interface
> + */

Typo in the sysfs pathname, should be /sys/kernel/perfmon
