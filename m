Return-Path: <linux-kernel-owner+w=401wt.eu-S1765920AbXHPVhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765920AbXHPVhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 17:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765264AbXHPVhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 17:37:34 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:47366 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932836AbXHPVhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 17:37:33 -0400
Date: Thu, 16 Aug 2007 23:37:32 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Dexter Filmore <Dexter.Filmore@gmx.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: which drive to pluck?
In-Reply-To: <200708162320.47645.Dexter.Filmore@gmx.de>
Message-ID: <Pine.LNX.4.64.0708162331000.5492@fbirervta.pbzchgretzou.qr>
References: <200708162320.47645.Dexter.Filmore@gmx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 16 2007 23:20, Dexter Filmore wrote:
>
>So I got 4 disks on the array, all on one controller. Now if I have to replace 
>a drive, how do I tell which one to pull out?
>I really wouldn't know which one is sdb and which sdc.

lsscsi.
(And when you have the [a:b:c:d] tuple, just follow the cable.)


	Jan
-- 
