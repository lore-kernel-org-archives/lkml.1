Return-Path: <linux-kernel-owner+w=401wt.eu-S1030476AbXEHP6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030476AbXEHP6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 11:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966433AbXEHP57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 11:57:59 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:53407 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S967725AbXEHP56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 11:57:58 -0400
Subject: Re: [PATCH 1/2] mca: mca_pentium_flag no longer used
From: James Bottomley <James.Bottomley@SteelEye.com>
To: andrew hendry <andrew.hendry@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <d45a3acc0705070549ic3b11a5pc8c299e08f914835@mail.gmail.com>
References: <d45a3acc0705070549ic3b11a5pc8c299e08f914835@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 08 May 2007 10:57:55 -0500
Message-Id: <1178639875.3737.27.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-07 at 22:49 +1000, andrew hendry wrote:
> The check for mca_pentium_flag was removed long ago.
> This cleans up the flag and documentation.

I can't apply this patch ... apparently the email is dual text and
html ... we really need text only for patch application.  Plus, it looks
like your email tool has converted all the tabs in the diff to spaces.

Could you resend.  If you can't get the mailer to comply, just attaching
the diff file usually works.

James


