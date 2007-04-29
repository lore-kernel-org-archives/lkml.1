Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbXD2CFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbXD2CFV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 22:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbXD2CFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 22:05:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:60309 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917AbXD2CEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 22:04:49 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [-mm patch] make drivers/misc/thinkpad_acpi:fan_mutex static
Date: Sat, 28 Apr 2007 21:53:30 -0400
User-Agent: KMail/1.9.5
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <20070428191938.GO3468@stusta.de> <20070428195821.GC2392@khazad-dum.debian.net>
In-Reply-To: <20070428195821.GC2392@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704282153.30858.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > This patch makes the needlessly global fan_mutex static.

applied.
thanks,
-Len
