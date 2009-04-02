Return-Path: <linux-kernel-owner+w=401wt.eu-S934206AbZDBK0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934206AbZDBK0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 06:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbZDBK00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 06:26:26 -0400
Received: from infra.metatux.net ([88.198.143.50]:57855 "EHLO
	infra.metatux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179AbZDBK00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 06:26:26 -0400
Message-ID: <49D492CD.9070500@metatux.net>
Date: Thu, 02 Apr 2009 12:26:21 +0200
From: Lars Buerding <lkml@metatux.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: floppy-drive storing inconsistent data using >=V2.6.28
 on AMD780 / SB700
References: <49CBB561.40102@metatux.net>
In-Reply-To: <49CBB561.40102@metatux.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again,

 > my floppy-drive is storing inconsistent data using Kernels >= V2.6.28 on
 > an AMD780/SB700-Mainboard.

Booting >= V2.6.28 with "hpet=disable" does the trick for me.

I also got a report of someone having the same trouble on an
AMD790/SB750 (Foxconn A7DA-S), his floppy is working as well
if the kernel is booted with that option.

Tested: v2.6.28, v2.6.29


Regards,
Lars
