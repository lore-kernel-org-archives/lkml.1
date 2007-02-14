Return-Path: <linux-kernel-owner+w=401wt.eu-S1751243AbXBNWs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243AbXBNWs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 17:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbXBNWs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 17:48:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:55399 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbXBNWsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 17:48:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Jones <davej@redhat.com>
Subject: Re: export of_find_property
Date: Wed, 14 Feb 2007 23:48:42 +0100
User-Agent: KMail/1.9.5
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070214215431.GA21779@redhat.com>
In-Reply-To: <20070214215431.GA21779@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702142348.43200.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX19UAHip7xTG9PDatLfgKDENZVV42I5yxgvt7qQyoYJYmD+MH5lbJGIfz7ErVUq5JyHnfb7NAJNDUjpvgDJjXLOPtf8rmERvnLKQNFL8YzadTQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 February 2007 22:54, Dave Jones wrote:
> Without this, building drivers/serial/of_serial.c as a module fails.
> 
> WARNING: ".of_find_property" [drivers/serial/of_serial.ko] undefined!
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

Acked-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>

Sorry about that one. This was introduced by a last-minute change,
and I didn't retest building as a module with it.
