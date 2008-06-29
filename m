Return-Path: <linux-kernel-owner+w=401wt.eu-S1761308AbYF2U3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761308AbYF2U3O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 16:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756329AbYF2U3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 16:29:00 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:59892 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbYF2U27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 16:28:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=J1VEjKIuf5yBLIFdN0htguqFz1kFYM/zg7WpIi9QECn+TUbuaXHxpMoeTIdE4t64qC
         qIcYUKr29JjCGG7/a3mX/bsevvDV3FgWlXQngp5xOOQ6Bkc7d2MjyFL8pl57Ve4iTX+I
         FiBWqOxqzshm1Erh9FuhVzkqSu4ggxyDpmMVA=
Message-ID: <dd18b0c30806291328o55d1be25t4d692344bbc3d129@mail.gmail.com>
Date: Sun, 29 Jun 2008 20:28:58 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10954] hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x011f000c
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <X8mbwW6K81I.A.9LE.N79ZIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
	 <X8mbwW6K81I.A.9LE.N79ZIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2008 at 6:18 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10954
> Subject         : hda_intel: azx_get_response timeout, switching to polling mode: last cmd=0x011f000c
> Submitter       : Justin Mattock <justinmattock@gmail.com>
> Date            : 2008-06-21 2:05 (9 days old)
> References      : http://marc.info/?l=linux-kernel&m=121401399622190&w=4
>
>
>

yes; still seeing this pop up,(problem is I can't reproduce this)

-- 
Justin P. Mattock
