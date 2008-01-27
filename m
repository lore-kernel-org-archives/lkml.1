Return-Path: <linux-kernel-owner+w=401wt.eu-S1759520AbYA0W3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520AbYA0W3q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 17:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbYA0W3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 17:29:37 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:34007 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbYA0W3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 17:29:36 -0500
Date: Sun, 27 Jan 2008 23:29:35 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Thanasis <thanasis@asyr.hopto.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_ROMFS_FS
In-Reply-To: <479CF645.8090009@asyr.hopto.org>
Message-ID: <Pine.LNX.4.64.0801272328480.1185@fbirervta.pbzchgretzou.qr>
References: <479CF645.8090009@asyr.hopto.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 27 2008 23:23, Thanasis wrote:
>
>Q: Do I need CONFIG_ROMFS_FS=y in order to use an initrd image to boot?
>
A: Only if your initrd is romfs. Which is usually not the case in this 
decade, much less this year.
