Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbYCMDe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbYCMDe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 23:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYCMDeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 23:34:20 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41170
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751518AbYCMDeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 23:34:19 -0400
Date: Wed, 12 Mar 2008 20:34:28 -0700 (PDT)
Message-Id: <20080312.203428.193707831.davem@davemloft.net>
To: bofh1234@hotmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: please fix 2.6.24.3 unifdef-y += if_addrlabel.h problem
From: David Miller <davem@davemloft.net>
In-Reply-To: <BAY101-W12A3C20A292C4D1841E697C8090@phx.gbl>
References: <BAY101-W12A3C20A292C4D1841E697C8090@phx.gbl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adam Turk <bofh1234@hotmail.com>
Date: Wed, 12 Mar 2008 23:17:00 -0400

> Can we please get a 2.6.24.4 kernel with the [patch 14/38] NET: Add
> if_addrlabel.h to sanitized headers patch reverted?

It will be reverted in the next 2.6.24.x kernel, this wasn't
deemed critical enough to release a kernel with only that
change.

