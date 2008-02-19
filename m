Return-Path: <linux-kernel-owner+w=401wt.eu-S1762666AbYBSWBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762666AbYBSWBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:01:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762501AbYBSWAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:00:50 -0500
Received: from mail.free-electrons.com ([88.191.46.45]:3187 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762464AbYBSWAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:00:48 -0500
Date: Tue, 19 Feb 2008 23:00:16 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       len.brown@intel.com, linux-acpi@vger.kernel.org,
       michael@free-electrons.com
Subject: Re: 2.6.25-rc2-mm1 (x64 thermal build failure)
Message-ID: <20080219230016.5b7ff43d@crazy>
In-Reply-To: <20080219094147.b9e0e99b.randy.dunlap@oracle.com>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	<20080216211603.bb4f3582.randy.dunlap@oracle.com>
	<20080216214410.b9699910.akpm@linux-foundation.org>
	<20080218111536.511c4fbc@crazy>
	<20080218041340.f1e46ec9.akpm@linux-foundation.org>
	<20080219165502.2c202759@crazy>
	<20080219094147.b9e0e99b.randy.dunlap@oracle.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Tue, 19 Feb 2008 09:41:47 -0800,
Randy Dunlap <randy.dunlap@oracle.com> a écrit :

> Does this patch apply to -mm?  Seem like No.

No, it was generated against 2.6.25-rc2.

> After converting it from mime(?) to ASCII

Probably due to my PGP-MIME signature. Will try to remember that
I should disable it next time.

> and fixing one #if (change "and" to "&&")

Oops. Fixed on my side too.

> & fixing patch rejects, it does build cleanly.

The rejects are probably due to the patch being applied to -mm. It
applies fine on -rc here.

Any opinion about whether the patch is clean ? Worth it ?

Thanks for testing the patch,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)
