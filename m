Return-Path: <linux-kernel-owner+w=401wt.eu-S1756961AbXIEUln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961AbXIEUln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 16:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757666AbXIEUl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 16:41:27 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:21791 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757664AbXIEUl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 16:41:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=gfJXpqwlgAeAaXRXpaeg90gTRBVGU8J4Wm0bLz5Xq4tL3aiAEuQROhiQi+BtxcIPxKGYEl4GALvA7wQ5vQ2Og8reneC4br3ot1Nw5mEE4zo13tWG51aiCxsFJlktUN2osUFHOGFiB0y0AM+upT3qOQLG9s6CXzftBN86bDkpDEU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: webmaster@dragonslave.de
Subject: Re: [PATCH] Override 80-wire cable detection for Toshiba S1800-814 (resend)
Date: Wed, 5 Sep 2007 21:42:44 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200708292341.14212.dex@dragonslave.de> <20070829225921.6ffd5f98@the-village.bc.nu> <200708311646.18494.dex@dragonslave.de>
In-Reply-To: <200708311646.18494.dex@dragonslave.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709052142.44806.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 August 2007, Daniel Exner wrote:
> Hi!
> 
> Please CC me, as I'm currently not subscribed to this list, thx.

applied but please inline patches instead of attaching them next time
(makes it much easier to review/apply them)
