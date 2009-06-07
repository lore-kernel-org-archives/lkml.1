Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbZFGNCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbZFGNCw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821AbZFGM60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 08:58:26 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:39301 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824AbZFGM6Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 08:58:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=pqeUQs5GZukYD6ZF3omjmSIEOTp1qwTbDrPwiF9wL97bgFSZEefq/jcy8pn+ZTsLdY
         A1224/ZR8b/kqFq7UijhWk4/GvCIYsjXE9Cud2j7ujevxHRQaq5zTleX9daDhGrq11mV
         y+SLG26iL8VzWUNawZWHTt7y4j7Ndhzphwnpk=
Date: Sun, 7 Jun 2009 14:58:23 +0200
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Bug #13362] rt2x00: slow wifi with correct basic rate bitmap
Message-ID: <20090607145823.4afaf8df@varda>
In-Reply-To: <D9VoutSOyXP.A.SVH.nZ7KKB@chimera>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera>
	<D9VoutSOyXP.A.SVH.nZ7KKB@chimera>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Sun,  7 Jun 2009 11:52:52 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> escribió:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).

 Well the problem is still there afaics.

> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13362
> Subject		: rt2x00: slow wifi with correct basic rate bitmap
> Submitter	: Alejandro Riveira <ariveira@gmail.com>
> Date		: 2009-05-22 13:32 (17 days old)
> 
> 
