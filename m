Return-Path: <linux-kernel-owner+w=401wt.eu-S1030968AbXD1DpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030968AbXD1DpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 23:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030969AbXD1DpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 23:45:16 -0400
Received: from relay4.usu.ru ([194.226.235.39]:60807 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030968AbXD1DpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 23:45:14 -0400
Message-ID: <4632C388.709@ums.usu.ru>
Date: Sat, 28 Apr 2007 09:46:16 +0600
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Ross Alexander <ross.alexander@uk.neceur.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: Kernel oops with 2.6.21 while using cdda2wav & cooked_ioctl (x64-64)
References: <4631AE19.7040705@uk.neceur.com>
In-Reply-To: <4631AE19.7040705@uk.neceur.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ross Alexander wrote:
> Modules linked in: nvidia(P)
> Tainted:P

With this, nobody will even look at your report. Please retry without 
proprietary modules.
