Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab0BVTcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 14:32:21 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:58448 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab0BVTcU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 14:32:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=KGg84q9ujZontFywMOWaoYeKCOep4q+vsLCoP1JbV7fJMzLX1kvLgOGLBBIf28sNbJ
         oXSi9sdAgrDkPq9LjAI4MXGfip9N3/23+FH+/aHPso/Sze5OWbFdeupZwxCtNamy5/Fb
         O+C1xnK34IZ/o8XFiJFQ1sr2Oipz7C6e80QIg=
MIME-Version: 1.0
In-Reply-To: <20100222141934.GA9030@darkstar>
References: <20100222141934.GA9030@darkstar>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 22 Feb 2010 14:25:29 -0500
Message-ID: <8bd0f97a1002221125pb3836e6nc82cee09f2709467@mail.gmail.com>
Subject: Re: [PATCH 03/06] kernel.h hexdump cleanup
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, Li Zefan <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 09:19, Dave Young wrote:
> --- /dev/null   1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/include/linux/hexdump.h   2010-02-16 17:33:16.000000000 +0800
> @@ -0,0 +1,30 @@
> +#ifndef _HEXDUMP_H
> +#define _HEXDUMP_H

use _LINUX_HEXDUMP_H to match other linux/ headers ?
-mike
