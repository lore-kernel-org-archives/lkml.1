Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbYLUGlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbYLUGlL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 01:41:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbYLUGk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 01:40:57 -0500
Received: from ik-out-1112.google.com ([66.249.90.180]:25612 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbYLUGk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 01:40:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=N/tDchHZbPPm0ZdAkdAyCsDKTX1O90AftXzolx7N4u5gvbjrCRIEb3yV40sE0Q7hfv
         +F14rvHVRcYjDKEdWsa8sknTp71kb31yodSc6tPpYymJbWugkHMJ2IBapToNvQirvKnL
         HceR5ygqyhdY5yhH9vxowUpi/HmbPC+oXCV8g=
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: Nick Warne <nick@ukfsn.org>
Subject: Re: [PATCH] New x86_64 boot logo
Date: Sun, 21 Dec 2008 11:40:01 +0500
User-Agent: KMail/1.10.92 (Linux/2.6.27-ARCH; KDE/4.1.85; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20081220105658.35ebd2bc@sauron.linicks.net> <494CF4A6.6050200@gmail.com> <20081220174024.26935b65@sauron.linicks.net>
In-Reply-To: <20081220174024.26935b65@sauron.linicks.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812211140.01788.patrakov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 December 2008 22:40:24 Nick Warne wrote:

> I haven't a clue what:
>
> "...as opposed to the old logo that had fine detail
> only in one of these places."
>
> means.

The only fine detail (i.e., the only place where the blur operation would 
remove something important from the image) in the old logo was the eyes of the 
penguin. This is the point where the viewer's attention is normally expected 
to be focused. In the new logo, there are three distant places where one has 
to focus the attention: the eyes, "6", and "4".

-- 
Alexander E. Patrakov
