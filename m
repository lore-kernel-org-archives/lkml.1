Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbYHKTu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbYHKTu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYHKTuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:50:20 -0400
Received: from www85.your-server.de ([213.133.104.85]:42537 "EHLO
	www85.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbYHKTuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:50:20 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.6.26: Filesystem capabilities 0.19 (was: ... 0.18)
References: <87proj2rgt.fsf@rat.lan>
From: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>
Date: Mon, 11 Aug 2008 21:50:13 +0200
In-Reply-To: <87proj2rgt.fsf@rat.lan> (Olaf Dietsche's message of "Fri\, 08 Aug 2008 22\:15\:46 +0200")
Message-ID: <87vdy78h6y.fsf@rat.lan>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Authenticated-Sender: webmaster@olafdietsche.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de> writes:

> This patch implements filesystem capabilities. It allows to
> run privileged executables without the need for suid root.
>
> Changes:
> - updated to 2.6.26
>
> This patch is available at:
> <http://www.olafdietsche.de/linux/capability/>

This is a fix only release, because of my sluttery :-(

- fixed compile error

Regards, Olaf.
