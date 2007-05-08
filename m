Return-Path: <linux-kernel-owner+w=401wt.eu-S967098AbXEHSfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967098AbXEHSfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 14:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966440AbXEHSfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 14:35:19 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966191AbXEHSfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 14:35:18 -0400
Date: Tue, 8 May 2007 11:34:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [GIT PULL] hwmon updates for 2.6.22
In-Reply-To: <20070508174529.7298cae4@hyperion.delvare>
Message-ID: <alpine.LFD.0.98.0705081133250.3974@woody.linux-foundation.org>
References: <20070508174529.7298cae4@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 May 2007, Jean Delvare wrote:
> 
> git://jdelvare.pck.nerim.net/jdelvare-2.6 hwmon-for-linus

This doesn't seem to be the right URL:

	"fatal: The remote end hung up unexpectedly"

(the git daemon on purpose doesn't tell *why* it hung up, for security 
reasons - you don't want to be able to probe other peoples machines for 
directory names etc).

		Linus
