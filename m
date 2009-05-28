Return-Path: <linux-kernel-owner+w=401wt.eu-S1764525AbZE1UiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764525AbZE1UiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762522AbZE1UiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:38:00 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:59233 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760788AbZE1UiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:38:00 -0400
To: pHilipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Eric Miao <eric.miao@marvell.com>
Subject: Re: [PATCH 1/3] regulator/max1586: support increased V3 voltage range
References: <878wkibmv9.fsf@free.fr>
	<1243487718-5423-2-git-send-email-philipp.zabel@gmail.com>
	<87skip2gxu.fsf@free.fr>
	<74d0deb30905281201k1eda2bcg39d2c1989533cbc8@mail.gmail.com>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Thu, 28 May 2009 22:36:46 +0200
In-Reply-To: <74d0deb30905281201k1eda2bcg39d2c1989533cbc8@mail.gmail.com> (pHilipp Zabel's message of "Thu\, 28 May 2009 21\:01\:26 +0200")
Message-ID: <87hbz52cdd.fsf@free.fr>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pHilipp Zabel <philipp.zabel@gmail.com> writes:

> Wow, thanks. I literally sent a patch to that effect a few seconds
> ago. Would you be ok with that one, too? I'd like not to lose too much
> resolution in the v3_gain parameter.
Yep. Acked it already.

Cheers.

--
Robert
