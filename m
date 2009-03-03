Return-Path: <linux-kernel-owner+w=401wt.eu-S1763086AbZCCWXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763086AbZCCWXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:23:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762468AbZCCWTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:19:35 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:38726 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762453AbZCCWTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:19:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VuAESYePC0TAQIMzdkYZviBPCU3qMDE3hHGnvYIu+HjByMXihSfYvrZCqt0zRSTfog
         VyfS7EMNFuBp05jir6uRcW4CkveBQDIk1ewkqZQlPQth71b+H8RqrIEJO90lc3St1Xl/
         OyWPz9cYUsil3CcHOzALkWX9rX6TA0H69+IUM=
MIME-Version: 1.0
In-Reply-To: <SLCXkuHtxAO.A.LtE.VWarJB@chimera>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
	 <SLCXkuHtxAO.A.LtE.VWarJB@chimera>
Date: Wed, 4 Mar 2009 00:19:30 +0200
Message-ID: <8f53421d0903031419m493b88bbifa911323279f4f0b@mail.gmail.com>
Subject: Re: [Bug #12574] possible circular locking dependency detected
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 3, 2009 at 9:25 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12574
> Subject         : possible circular locking dependency detected
> Submitter       : Michael S. Tsirkin <m.s.tsirkin@gmail.com>
> Date            : 2009-01-29 11:35 (34 days old)
> References      : http://lkml.org/lkml/2009/2/9/205
>
>
>

I don't seem to observe this warning in v2.6.29-rc6 anymore.
