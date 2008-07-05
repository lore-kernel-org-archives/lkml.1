Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbYGEOJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbYGEOJT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 10:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbYGEOJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 10:09:12 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:47438 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbYGEOJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 10:09:11 -0400
Date: Sat, 5 Jul 2008 16:09:10 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Charlie Brej <linux-kernel@brej.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pcspkr/vt_ioctl: PC speaker volume control
In-Reply-To: <486F7D05.4000403@brej.org>
Message-ID: <alpine.LNX.1.10.0807051607480.28765@fbirervta.pbzchgretzou.qr>
References: <486A98EC.1090502@brej.org> <486F7D05.4000403@brej.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2008-07-05 15:54, Charlie Brej wrote:

> Charlie Brej wrote:
>> The attached patch allows the system to control the volume of the system
>> bell.
>
> Has anyone looked at this? Should I send it to someone in particular or is
> there no interest in it?

Well how I should I put it... there is the PC speaker sound driver
from Stas Sergeev, with which beeps can already be produced in
varying volume levels -- just feed it the appropriate PCM data. Of
course, console usually does not play WAV files. :o)
