Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbYLDHbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbYLDHbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 02:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbYLDHb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 02:31:27 -0500
Received: from mail-gx0-f18.google.com ([209.85.217.18]:46805 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbYLDHb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 02:31:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=kbGN5dEjbBItxi7bG/Gx4SmI1196QWjcsh6aoLGXhInXb4L8eSzEUkV47R3pd0uU+U
         fYQmGhe6Zs1MhKjmpylkkL8Spt/2162Y8QHBRrGdIcphqaqBBtwvA7HB2FjnlCtQOiXm
         EDi2X/kzb6EF5FFw0WG+9KseI4BiqHuu4vYlQ=
Message-ID: <cd50ff710812032331g69a64a91l89ea239481102b61@mail.gmail.com>
Date: Thu, 4 Dec 2008 08:31:25 +0100
From: "Frederik Deweerdt" <frederik.deweerdt@gmail.com>
Reply-To: frederik.deweerdt@gmail.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #12047] ACPI toshiba: only register rfkill if bt is enabled
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Andrey Borzenkov" <arvidjaar@mail.ru>
In-Reply-To: <bfPM5B8Tx2B.A.V_H.OpxNJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <QFIA5HSHV8B.A.2aG.hoxNJB@chimera>
	 <bfPM5B8Tx2B.A.V_H.OpxNJB@chimera>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rafael,
On Wed, Dec 3, 2008 at 10:58 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12047
> Subject         : ACPI toshiba: only register rfkill if bt is enabled
> Submitter       : Andrey Borzenkov <arvidjaar@mail.ru>
> Date            : 2008-10-28 19:10 (37 days old)
> References      : http://marc.info/?l=linux-kernel&m=122522113619025&w=2
> Handled-By      : Frederik Deweerdt <frederik.deweerdt@gmail.com>
> Patch           : http://marc.info/?l=linux-kernel&m=122526843117478&w=2
Still should be listed, an updated patch is in -mm now.

Regards,
Frederik
