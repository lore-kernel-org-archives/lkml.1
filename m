Return-Path: <linux-kernel-owner+w=401wt.eu-S933057AbXH3SZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057AbXH3SZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 14:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932575AbXH3SZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 14:25:13 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42471 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479AbXH3SZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 14:25:12 -0400
Date: Thu, 30 Aug 2007 20:25:10 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Just Marc <marc@corky.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: file system for solid state disks
In-Reply-To: <46CFEB36.9020806@corky.net>
Message-ID: <Pine.LNX.4.64.0708302024320.24730@fbirervta.pbzchgretzou.qr>
References: <46CFEB36.9020806@corky.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 25 2007 09:41, Just Marc wrote:
>
> On SSDs which contain built in wear leveling, pretty much any file 
> system can be used.  For SSDs that lack such low level housekeeping, 
> use stuff like JFFS2.

The question is, how can you find out whether it does automatic 
wear-leveling? (Perhaps when a CF is advertised as "holds 10 years!"?)


	Jan
-- 
