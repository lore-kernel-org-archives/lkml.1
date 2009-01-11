Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004AbZAKN5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbZAKN5T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 08:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbZAKN5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:57:08 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:39876 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbZAKN5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:57:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pA0KSTNlKFKujHQjZwAuPybQa9YuyJF36NKaVmbDlnnV0O89yr1Jx2rj2rwoVe6j7x
         rChEfqBlFSvKOYkOlD2jLjZ2rGsuhpLQ9Av7pGOxwDTF5sW7SIR7pEGiDDjvAAcmTGgl
         ZHk6B6bfqmVxrt6I5pUDW/yiziNCE4nT9vDSM=
Message-ID: <b6a2187b0901110557v1679d942if536fc7d59fd99aa@mail.gmail.com>
Date: Sun, 11 Jan 2009 21:57:04 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #12422] 2.6.28-git can't resume from str
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Daniel Drake" <dsd@gentoo.org>, "Phil Dibowitz" <phil@ipom.com>
In-Reply-To: <oWTznAnH9BI.A.qDH.EHfaJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera>
	 <oWTznAnH9BI.A.qDH.EHfaJB@chimera>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 7:16 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12422
> Subject         : 2.6.28-git can't resume from str
> Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
> Date            : 2009-01-10 1:39 (2 days old)
> References      : http://marc.info/?l=linux-kernel&m=123155157909282&w=4

Latest git pull still not fixed.

Jeff.
