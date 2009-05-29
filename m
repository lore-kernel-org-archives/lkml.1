Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbZE2GXC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbZE2GXC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 02:23:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbZE2GWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 02:22:54 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:60605 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbZE2GWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 02:22:53 -0400
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Eric Miao <eric.miao@marvell.com>
Subject: Re: [PATCH 4/5] pxa/mioa701: add V3 gain configuration for Maxim 1586 voltage regulator
References: <878wkibmv9.fsf@free.fr>
	<1243487718-5423-3-git-send-email-philipp.zabel@gmail.com>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Fri, 29 May 2009 08:22:44 +0200
In-Reply-To: <1243487718-5423-3-git-send-email-philipp.zabel@gmail.com> (Philipp Zabel's message of "Thu\, 28 May 2009 07\:15\:17 +0200")
Message-ID: <87fxeov363.fsf@free.fr>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philipp Zabel <philipp.zabel@gmail.com> writes:

> Maxim 1586 V3 gain can be configured by external resistors
> (R24, R25) connected to the FB3 pin. To avoid accidental
> overvoltage, it now requires this gain to be configured
> explicitly.
>
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

--
Robert
