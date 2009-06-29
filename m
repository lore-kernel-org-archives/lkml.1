Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbZF2AWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbZF2AWG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 20:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758624AbZF2ASk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 20:18:40 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:19065 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758635AbZF2ASi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 20:18:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PuUrWTVpKHXKOgG9m9xjXxbyoUnW3VOraZK/fIzfOMir5yKBci4aG0PV5QhuWBHLGJ
         Nfm0OhnPJMLxPJyHb0pSt1IRk10raAInoNr+ReAeoY017eYyMEAvtOVh1U2zshP+34ci
         4mZ9h+0YLue8XbJQlGrM1OEI0d+UcC2yM9xPk=
MIME-Version: 1.0
In-Reply-To: <6JJ2m5kyucK.A.wuD.OJASKB@chimera>
References: <ij4ZQY4URcP.A.F3B.vIASKB@chimera>
	 <6JJ2m5kyucK.A.wuD.OJASKB@chimera>
Date: Mon, 29 Jun 2009 10:18:41 +1000
Message-ID: <21d7e9970906281718q74023c28w67d0339a0096e228@mail.gmail.com>
Subject: Re: [Bug #13610] radeon kms invalid edid data at lvds
From: Dave Airlie <airlied@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Nicolas Reinecke <pl4nkton@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 10:11 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13610
> Subject         : radeon kms invalid edid data at lvds
> Submitter       : Nicolas Reinecke <pl4nkton@googlemail.com>
> Date            : 2009-06-23 19:53 (6 days old)
>
>

This isn't a regression, its running kms code in a staging driver.

Dave.
