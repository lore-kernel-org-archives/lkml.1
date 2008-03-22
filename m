Return-Path: <linux-kernel-owner+w=401wt.eu-S1758306AbYCVXix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306AbYCVXix (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 19:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbYCVXiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 19:38:46 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42153 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021AbYCVXip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 19:38:45 -0400
Date: Sun, 23 Mar 2008 00:38:44 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Bernd Schubert <bernd-schubert@gmx.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: deadline unfairness
In-Reply-To: <200803221225.26728.bernd-schubert@gmx.de>
Message-ID: <alpine.LNX.1.00.0803230037240.28078@fbirervta.pbzchgretzou.qr>
References: <200803221225.26728.bernd-schubert@gmx.de>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 22 2008 12:25, Bernd Schubert wrote:
>
> some it seems the deadline scheduler is rather unfair. Below is an example
> of md-raid6 initialization of md3, md4 and md5. All three md-devices
> do share the same blockdevices (we have patched md to allow
> parallel rebuild of shared block devices, since for us the cpu is the
> bottleneck and not the block device).

Could you share this patch? It would be really intersting for use
with fast based block devices (flash, ramdisk, and such)!

