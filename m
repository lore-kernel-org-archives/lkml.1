Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbXFOPzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbXFOPzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbXFOPze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:55:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54516 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbXFOPzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:55:33 -0400
From: Olaf Dietsche <olaf+list.linux-acpi@olafdietsche.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.22-rc3][ACPI?] Resume from s2r doesn't work.
References: <878xb35sje.fsf@goat.bogus.local> <20070612153102.GD5986@ucw.cz>
	<87fy4vmxva.fsf@goat.bogus.local> <20070614195659.GE9442@ucw.cz>
Date: Fri, 15 Jun 2007 17:55:29 +0200
In-Reply-To: <20070614195659.GE9442@ucw.cz> (Pavel Machek's message of "Thu,
	14 Jun 2007 19:56:59 +0000")
Message-ID: <87myz16wlq.fsf@goat.bogus.local>
User-Agent: Gnus/5.110006 (No Gnus v0.6) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX1+HdHdzvHXYGEYSPvrqPXxoZI6vjSeTwbKj2YQ
 a7tMCHhba83P6rSpYOcO2xPtkzHlhSkFtjmDrAJDX/8RW2W2JS
 Z5/Jjl4GUCjiknCbaXcZg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> noapic/nolapic will not help with video issue. try s2ram from
> suspend.sf.net.

I already tried s2ram, no improvement so far.

Regards, Olaf.
