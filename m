Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbYHKTtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbYHKTtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbYHKTtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:49:33 -0400
Received: from www85.your-server.de ([213.133.104.85]:42501 "EHLO
	www85.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbYHKTtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:49:32 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.6.26: access permission filesystem 0.22 (was ... 0.21)
References: <87wsir2rh8.fsf@rat.lan>
From: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>
Date: Mon, 11 Aug 2008 21:49:25 +0200
In-Reply-To: <87wsir2rh8.fsf@rat.lan> (Olaf Dietsche's message of "Fri\, 08 Aug 2008 22\:15\:31 +0200")
Message-ID: <87zlnj8h8a.fsf@rat.lan>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Authenticated-Sender: webmaster@olafdietsche.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de> writes:

> This patch adds a new permission managing file system.
> Furthermore, it adds two modules, which make use of this file system.
>
> One module allows granting capabilities based on user-/groupid. The
> second module allows to grant access to lower numbered ports based on
> user-/groupid, too.
>
> Changes:
> - updated to 2.6.26
>
> This patch is available at:
> <http://www.olafdietsche.de/linux/accessfs/>

This is a fix only release, because of my sluttery :-(

- fixed compile error

Regards, Olaf.
