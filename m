Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbXKATtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbXKATtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 15:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbXKATti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 15:49:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60771 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbXKATti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 15:49:38 -0400
To: Jan Kara <jack@suse.cz>
Cc: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.6.23: Filesystem capabilities 0.17
References: <871wbhc0zj.fsf@olafdietsche.de>
	<20071031170853.GD28809@atrey.karlin.mff.cuni.cz>
From: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>
Date: Thu, 01 Nov 2007 20:49:32 +0100
Message-ID: <87tzo5925v.fsf@olafdietsche.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX18GodfpDmy8LpS/CVsiqhLtGEDZIE2NcRn1ewF
 GgqN1gpG++5Hcu1ebxjFqzGiqtzgsB1P4FPZVYyxmKuJb2vToY
 NUlelxAr1sUGnxBzUbGvw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>> This patch implements filesystem capabilities. It allows to
>> run privileged executables without the need for suid root.
>   Hmm, is there some "design document" so that one does not have to poke
> through the code and find out what it's actually trying to do?

What do you mean with "trying to do"? I thought this is obvious, it
provides executables with filesystem capabilities.

> Also why don't you use extended attributes or store them inside the
> executable like Pavel did (you link it from your web page).

The links from my web page are there to show alternatives, nothing
else. When I started in 2002, xattr where pretty new or nonexistant.

Regards, Olaf.
