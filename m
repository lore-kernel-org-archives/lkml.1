Return-Path: <linux-kernel-owner+w=401wt.eu-S1755076AbZAUWoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbZAUWoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 17:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbZAUWoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 17:44:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52440
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753652AbZAUWoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 17:44:06 -0500
Date: Wed, 21 Jan 2009 14:44:08 -0800 (PST)
Message-Id: <20090121.144408.193919099.davem@davemloft.net>
To: tklein@de.ibm.com
Cc: jeff@garzik.org, themann@de.ibm.com, netdev@vger.kernel.org,
       hering2@de.ibm.com, linux-kernel@vger.kernel.org, raisch@de.ibm.com,
       linuxppc-dev@ozlabs.org, ossthema@de.ibm.com
Subject: Re: [PATCH 1/3] ehea: Use net_device_ops structure
From: David Miller <davem@davemloft.net>
In-Reply-To: <200901211549.01120.tklein@de.ibm.com>
References: <200901211549.01120.tklein@de.ibm.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Klein <tklein@de.ibm.com>
Date: Wed, 21 Jan 2009 15:49:00 +0100

> Adapt to lately introduced net_device_ops structure.
> 
> Signed-off-by: Thomas Klein <tklein@de.ibm.com>

Applied.
