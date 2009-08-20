Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbZHTSFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbZHTSFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 14:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbZHTSFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 14:05:36 -0400
Received: from outbound-mail-319.bluehost.com ([67.222.54.251]:56211 "HELO
	outbound-mail-319.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755137AbZHTSFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 14:05:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ePodx9LwfafyImJuXW6pWMVM/AhWHvcNg8ozVR+Lu44WaEbuKs3/iiskeyrrKIX4NOMTgGHkCz7C1GN4RP+U/JvCPuNW6r7Bs55u6VPKUk2AMwkuRd5lnkp5O4sTKiSb;
Date: Thu, 20 Aug 2009 11:05:32 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Cijoml Cijomlovic Cijomlov" <cijoml@volny.cz>
Subject: Re: [Bug #13634] [drm:drm_wait_vblank] *ERROR* failed to acquire
 vblank counter, -22
Message-ID: <20090820110532.24d5b2ea@jbarnes-g45>
In-Reply-To: <Era7U-todKF.A.wmC.ZmIjKB@chimera>
References: <xDf-7eSwYsC.A.-6B.klIjKB@chimera>
	<Era7U-todKF.A.wmC.ZmIjKB@chimera>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009 22:40:45 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.29 and 2.6.30.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.29 and 2.6.30.  Please verify if it still
> should be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13634
> Subject		: [drm:drm_wait_vblank] *ERROR* failed to
> acquire vblank counter, -22 Submitter	: Cijoml Cijomlovic
> Cijomlov <cijoml@volny.cz> Date		: 2009-06-27 07:02 (54
> days old)

Patches to fix this have been queued.

-- 
Jesse Barnes, Intel Open Source Technology Center
