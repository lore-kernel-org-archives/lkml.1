Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbZBCLTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbZBCLTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 06:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbZBCLTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 06:19:05 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:36574 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbZBCLTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 06:19:04 -0500
Date: Tue, 3 Feb 2009 12:18:49 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mark Lord <lkml@rtr.ca>
Cc: linux-i2c@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ir-kbd-i2c: support Hauppauge HVR-1600 R/C port
Message-ID: <20090203121849.37f59fb3@hyperion.delvare>
In-Reply-To: <4987B965.6020609@rtr.ca>
References: <4987B965.6020609@rtr.ca>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, 02 Feb 2009 22:26:29 -0500, Mark Lord wrote:
> Update the ir-kbd-i2c driver to recognize the remote-control port
> on the Hauppauge HV-1600 hybrid tuner card.
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>

Neither the linux-i2c nor the linux-kernel mailing lists are
appropriate for this patch. Please post to linux-media and/or
video4linux-list@redhat.com as listed in file MAINTAINERS.

Thanks,
-- 
Jean Delvare
