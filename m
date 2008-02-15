Return-Path: <linux-kernel-owner+w=401wt.eu-S932853AbYBOKVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853AbYBOKVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 05:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758216AbYBOKVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 05:21:35 -0500
Received: from baikonur.stro.at ([213.239.196.228]:36044 "EHLO
	baikonur.stro.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129AbYBOKVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 05:21:34 -0500
Date: Fri, 15 Feb 2008 11:21:32 +0100
From: maximilian attems <max@stro.at>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Norbert Preining <preining@logic.at>, linux-kernel@vger.kernel.org
Subject: Re: Huawei E220 and usb storage
Message-ID: <20080215102132.GE6053@stro.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, did new tests with 2.6.24-rc2:
> - with plain kernel the usb-storage modules attaches and detaches
>   permanently a virtual cd drive, I stopped after 30+ iterations.

afais this is caused by hal.
when i stop hal this bouncy behaviour stops.

also it doesn't happen if you put your huawei on before boot.
