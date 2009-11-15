Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbZKOO0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbZKOO0z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 09:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbZKOO0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 09:26:54 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:63625 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbZKOO0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 09:26:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=vx+sYEcXRjxXDIL2xyS/AUYI3yHeKEcgR/7k6fUar+dvpIq9A4jAcv6LUA1Msvzit2
         fBU4KGI7P9Jv2W/GhIvAtE4YgF/QUjqQPK0ELFc0tp8tjhRXNhkq2pEv3TMMD2PEEFkD
         EyMTz2XP7sR/CF4oarMfoMmgLsiLXevwUT4Xc=
Message-ID: <4B000A4C.30103@gmail.com>
Date: Sun, 15 Nov 2009 17:03:56 +0300
From: Andrey Polovov <andrey.polovov@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090123)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Getting HDD serial in kernel space
References: <4AFE95DE.3070308@gmail.com>
In-Reply-To: <4AFE95DE.3070308@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Polovov:

> How can I do it in kernel space (it is one hdd in machine, plugged with
> SATA)?

What I need is a small piece of code that can help me in getting a list
(ata_device array?) of plugged HDDs and their serial numbers.
