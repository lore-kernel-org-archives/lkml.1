Return-Path: <linux-kernel-owner+w=401wt.eu-S1422986AbXEAAIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422986AbXEAAIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 20:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422894AbXEAAIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 20:08:41 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:7594 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422982AbXEAAIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 20:08:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BMsAMlRPvRXPI8LOzRidYIGccG/eKb1ZQ2bJ9ozKwUo8UE2E3vUlTz9rv0D8SPTphNr7JeSd0q4WvFkgL2t429O0CO89+G5K47cf0WW3XrMb5CWlPn1W/LXSFsy5qtjGAgBuvr25eSXePx0BkHFbFBgLbwbeDlM+LVEPrRk0UiQ=
Subject: Re: [PATCH 33/36] Use menuconfig objects II - video/logo
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.61.0704301355430.29151@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr>
	 <Pine.LNX.4.61.0704301355430.29151@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Tue, 01 May 2007 08:08:30 +0800
Message-Id: <1177978110.4372.25.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-30 at 13:56 +0200, Jan Engelhardt wrote:
> Change Kconfig objects from "menu, config" into "menuconfig" so
> that the user can disable the whole feature without having to
> enter the menu first.
> 
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Acked-by: Antonino Daplas <adaplas@gmail.com>

But I'll pick this up nevertheless.

Tony


