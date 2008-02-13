Return-Path: <linux-kernel-owner+w=401wt.eu-S1760776AbYBMWGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760776AbYBMWGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:06:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762207AbYBMWDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:03:37 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:56459 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935148AbYBMWDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:03:36 -0500
Date: Wed, 13 Feb 2008 23:03:35 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Adrian Bunk <bunk@kernel.org>
cc: "Ed L. Cashin" <ecashin@coraid.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] #if 0 aoedev_isbusy()
In-Reply-To: <20080213213002.GT3383@cs181133002.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0802132303150.29154@fbirervta.pbzchgretzou.qr>
References: <20080213213002.GT3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 13 2008 23:30, Adrian Bunk wrote:
>
>This patch #if 0's the no longer used aoedev_isbusy().

Why not just remove it? (It can be resurrected from earlier
revisions should it be needed again.)
