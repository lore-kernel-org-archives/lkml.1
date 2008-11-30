Return-Path: <linux-kernel-owner+w=401wt.eu-S1752270AbYK3Ix1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbYK3Ix1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 03:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbYK3IxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 03:53:18 -0500
Received: from senator.holtmann.net ([87.106.208.187]:39199 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbYK3IxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 03:53:17 -0500
Subject: Re: [PATCH 4/5] drivers/bluetooth: change simple_strtol to
 simple_strtoul
From: Marcel Holtmann <marcel@holtmann.org>
To: Julia Lawall <julia@diku.dk>
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0811251414330.11897@pc-004.diku.dk>
References: <Pine.LNX.4.64.0811251414330.11897@pc-004.diku.dk>
Content-Type: text/plain
Date: Sun, 30 Nov 2008 09:53:13 +0100
Message-Id: <1228035193.9176.3.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

> From: Julia Lawall <julia@diku.dk>
> 
> Since size, addr, fcs, and tmp are unsigned, it would seem better to use
> simple_strtoul that simple_strtol.
> 
> A simplified version of the semantic patch that makes this change is as
> follows: (http://www.emn.fr/x-info/coccinelle/)

patch has been applied to my tree. Thanks.

Regards

Marcel


