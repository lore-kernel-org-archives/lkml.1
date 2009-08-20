Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbZHTGy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbZHTGy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 02:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbZHTGy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 02:54:29 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:44506 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbZHTGy2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 02:54:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NVu5T5dLChR+k/mPbZShOC57mr6/roqW4Lk5feAsfAzx2C6o6TMRPzA2aIcrEnFH+w
         GIVp/ulNYgCRMva1ps0W2pvGo3ZhsyJyGWSjaOatfRvl5sPj1/AQF3vNLCjFF9YBGfiU
         AavlQX5Y0ndCjCzrf+RwUUauREnh5yDds42Bo=
MIME-Version: 1.0
In-Reply-To: <ADSuNT6McuD.A.Kp._NIjKB@chimera>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
	 <ADSuNT6McuD.A.Kp._NIjKB@chimera>
Date: Thu, 20 Aug 2009 08:54:28 +0200
Message-ID: <b637ec0b0908192354o36e8c99qfff7718f26bdfd7b@mail.gmail.com>
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

This bug is still present (also in wireless-testing).

On Wed, Aug 19, 2009 at 10:26 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
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
> Date            : 2009-08-06 20:15 (14 days old)
> References      : http://marc.info/?l=linux-kernel&m=124958978600600&w=4
>
>
>
