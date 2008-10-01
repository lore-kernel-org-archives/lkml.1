Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbYJATdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbYJATdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 15:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbYJATc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 15:32:59 -0400
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:54140 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753543AbYJATc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 15:32:58 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: CD tray closes spontaneously after opening it
To: Frans Pop <elendil@planet.nl>, Kay Sievers <kay.sievers@vrfy.org>,
       Tony Vroon <tony@vroon.org>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Reply-To: 7eggert@gmx.de
Date: Wed, 01 Oct 2008 21:43:08 +0200
References: <bhKXZ-55E-11@gated-at.bofh.it> <bhTyc-7OL-11@gated-at.bofh.it> <bhTHP-8fv-7@gated-at.bofh.it> <biapp-4PE-1@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1Kl7bJ-00026W-7K@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop <elendil@planet.nl> wrote:

> BTW, I have considered a hardware problem like a short in the eject
> button, but I don't think that's it.

I've got a CDROM with a defective stopper. The tray will stop at the working
stopper, while the broken side goes a little further, and then back triggering
the "user-pushes-tray-in"-sensor.

