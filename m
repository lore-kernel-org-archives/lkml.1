Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbYAXLDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbYAXLDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 06:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbYAXLDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 06:03:32 -0500
Received: from spiffy.freedom.ind.br ([201.35.65.91]:52809 "EHLO
	freedom.ind.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753748AbYAXLDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 06:03:31 -0500
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: USB looks to be restarting
References: <Pine.LNX.4.44L0.0801231716460.6786-100000@iolanthe.rowland.org>
From: Otavio Salvador <otavio@debian.org>
Organization: O.S. Systems Ltda.
X-URL: http://www.debian.org/~otavio/
X-Attribution: O.S.
Date: Thu, 24 Jan 2008 09:04:04 -0200
In-Reply-To: <Pine.LNX.4.44L0.0801231716460.6786-100000@iolanthe.rowland.org> (Alan Stern's message of "Wed\, 23 Jan 2008 17\:18\:07 -0500 \(EST\)")
Message-ID: <87sl0n1o4b.fsf@ossystems.com.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

>> > Does someone has any idea how to solve it?
>
> Unplug the device attached to port 2 of bus 1.  Apparently it is 
> spontaneously disconnecting and reconnecting itself over and over.

The machine power suply had problem and then it needed to be
replace. Doing it solved the issue.

Probably the power suply wasn't providing enough power.

-- 
        O T A V I O    S A L V A D O R
---------------------------------------------
 E-mail: otavio@debian.org      UIN: 5906116
 GNU/Linux User: 239058     GPG ID: 49A5F855
 Home Page: http://otavio.ossystems.com.br
---------------------------------------------
"Microsoft sells you Windows ... Linux gives
 you the whole house."
