Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab0BABNE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 20:13:04 -0500
Received: from mail-iw0-f173.google.com ([209.85.223.173]:64477 "EHLO
	mail-iw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab0BABNB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 20:13:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kTytrMkLBFLJ/2eGiAy6vzTWOCMiXmTo5XZOFgddbhYeIxZBIuGH9c7bVNTE0n0OT8
         O4LGtfRk9Wa+g8v+LRT2hidyrTQG5Vd5GFUg5I6/T7jiTcTP5sHWKWYT4Yt/eVbaGk5Z
         88RiV8beXSWO+fa7kmPh39z2iZm+587qtcPyQ=
MIME-Version: 1.0
In-Reply-To: <de962C6zBxL.A.AMF.tFiZLB@chimera>
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
	 <de962C6zBxL.A.AMF.tFiZLB@chimera>
Date: Sun, 31 Jan 2010 19:13:00 -0600
Message-ID: <51f3faa71001311713sf4dbd45w240003a77de24f68@mail.gmail.com>
Subject: Re: [Bug #14922] 2.6.32 seemed to have broken nVidia MCP7A sata 
	controller
From: Robert Hancock <hancockrwd@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Mike Cui <cuicui@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 31, 2010 at 6:43 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14922
> Subject         : 2.6.32 seemed to have broken nVidia MCP7A sata controller
> Submitter       : Mike Cui <cuicui@gmail.com>
> Date            : 2009-12-19 6:13 (44 days old)
> References      : http://marc.info/?l=linux-ide&m=126120323407742&w=4
> Handled-By      : Jeff Garzik <jeff@garzik.org>
>                  Robert Hancock <hancockrwd@gmail.com>

Still outstanding. I posted a patch that should fix the problem,
waiting for feedback from the reporter.
