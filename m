Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbYIMIvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbYIMIvx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 04:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYIMIvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 04:51:44 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:6173 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbYIMIvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 04:51:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=Zxqjn3roSch08wd9O3DwhPYlWXqOzrMZvKDl485WKs7h1pOftvi0K6MiSQQ7Rlb5wt
         3pvbXNuC67CGzArbOrOPWw39eiew6I/noF+pumY5/r8kJdbiFUKQD6FJ2IChh7sD6HQe
         2JkJ9vbhL4gPW5+yTeiabh9rdDIBda6398UYc=
Message-ID: <48CB7F1A.7080201@tuffmail.co.uk>
Date: Sat, 13 Sep 2008 09:51:38 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       =?UTF-8?B?Um9nw6lyaW8gQnJpdG8=?= <rbrito@ime.usp.br>
Subject: Re: [Bug #11553] Strange looking line from "ps aux"
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik> <SpS7rta8n4.A.o2F.ubsyIB@albercik>
In-Reply-To: <SpS7rta8n4.A.o2F.ubsyIB@albercik>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11553
> Subject		: Strange looking line from "ps aux"
> Submitter	: Rogério Brito <rbrito@ime.usp.br>
> Date		: 2008-09-11 17:43 (2 days old)
> References	: http://marc.info/?l=linux-kernel&m=122115506018275&w=4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-testers" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

Isn't this another instance of
<http://bugzilla.kernel.org/show_bug.cgi?id=11209>?

If you can try 2.6.27-rc6, that should fix it.

Alan
