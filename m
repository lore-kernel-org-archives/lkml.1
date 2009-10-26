Return-Path: <linux-kernel-owner+w=401wt.eu-S1756360AbZJZUPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360AbZJZUPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 16:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbZJZUPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 16:15:44 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:41007 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbZJZUPn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 16:15:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RzNHdmJSv2MIYiGyWE0K8q9v3vZtoztv2cGqnjzEAKpvoqtEwngGX+BRJClKwOfC+b
         GLdO9zIWJgfHU7PU48NtMhQ+WcDf5IH72ZBsM7kjDiMnEh424tkfbrq8jmz/uhGjjksJ
         IWNuJ75w9kdES+FnDh9ClVK4HlV/qL45vKOZM=
MIME-Version: 1.0
In-Reply-To: <6dRYo8ss7vL.A.xRH.vre5KB@chimera>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
	 <6dRYo8ss7vL.A.xRH.vre5KB@chimera>
Date: Mon, 26 Oct 2009 21:15:47 +0100
Message-ID: <b637ec0b0910261315u43033948ge041cf70292bfa58@mail.gmail.com>
Subject: Re: [Bug #14372] ath5k wireless not working after suspend-resume - 
	eeepc
From: Fabio Comolli <fabio.comolli@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Still present in -rc5

On Mon, Oct 26, 2009 at 7:55 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.31.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14372
> Subject         : ath5k wireless not working after suspend-resume - eeepc
> Submitter       : Fabio Comolli <fabio.comolli@gmail.com>
> Date            : 2009-10-03 15:36 (24 days old)
> References      : http://lkml.org/lkml/2009/10/3/91
>
>
>
