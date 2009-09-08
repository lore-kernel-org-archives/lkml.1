Return-Path: <linux-kernel-owner+w=401wt.eu-S1752022AbZIHTit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbZIHTit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 15:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbZIHTis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 15:38:48 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:64876 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbZIHTis convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 15:38:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lLiF4JB5PaMkvrDCtL+BzGVzA44yeIYTb0SMc+zLuWUfeu+9f0zDeC2LX8GS6M0msm
         vmvSVt9RRiVY0sPmp21BaZWAEKcM0gQMBY65QDe+L7d2ZH6vHxzhqSwCo0SjQyw5As8x
         Z9yhkmw6qpeAOgDPWYKdUsAJ6ui2kMtAr6N8U=
MIME-Version: 1.0
In-Reply-To: <Vm51Upp4EV.A.OYD.1fBpKB@chimera>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
	 <Vm51Upp4EV.A.OYD.1fBpKB@chimera>
Date: Tue, 8 Sep 2009 21:30:44 +0200
Message-ID: <b637ec0b0909081230y1b9d2abbo258662343cca7932@mail.gmail.com>
Subject: Re: [Bug #13943] WARNING: at net/mac80211/mlme.c:2292 with ath5k
From: Fabio Comolli <fabio.comolli@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Still present in -rc9

On Sun, Sep 6, 2009 at 7:24 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13943
> Subject         : WARNING: at net/mac80211/mlme.c:2292 with ath5k
> Submitter       : Fabio Comolli <fabio.comolli@gmail.com>
> Date            : 2009-08-06 20:15 (32 days old)
> References      : http://marc.info/?l=linux-kernel&m=124958978600600&w=4
>
>
>
