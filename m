Return-Path: <linux-kernel-owner+w=401wt.eu-S1752527AbZG0Ok3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbZG0Ok3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 10:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbZG0Ok2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 10:40:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41847 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752019AbZG0Ok2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 10:40:28 -0400
Date: Mon, 27 Jul 2009 10:40:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Peter Chubb <peterc@gelato.unsw.edu.au>
Subject: Re: [Bug #13472] Oops with minicom and USB serial
In-Reply-To: <H5-1lZIIeYK.A.sQH.6XObKB@chimera>
Message-ID: <Pine.LNX.4.44L0.0907271039260.5614-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jul 2009, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13472
> Subject		: Oops with minicom and USB serial
> Submitter	: Peter Chubb <peterc@gelato.unsw.edu.au>
> Date		: 2009-06-05 1:37 (52 days old)
> References	: http://marc.info/?l=linux-kernel&m=124416901026700&w=4
> Handled-By	: Alan Stern <stern@rowland.harvard.edu>

This bug has been fixed in 2.6.30.stable by commit
b6cd9d132aa5e2ef0abdd1d5171e45dad9aafc29.

Alan Stern

