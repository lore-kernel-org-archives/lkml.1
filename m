Return-Path: <linux-kernel-owner+w=401wt.eu-S1761307AbYBAWia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761307AbYBAWia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 17:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758098AbYBAWhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 17:37:14 -0500
Received: from an-out-0708.google.com ([209.85.132.240]:64216 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbYBAWhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 17:37:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=hlfLmaPOlrLnFhNukpzz+m+5k/NoJJrB90CD0dshUe2dsplJ23iyiv+afCAmfRdrJ2EuEPGJnlA8XDYRacJHSPxtwX9VVYxDoQVpAiu8rpW+TrbYP1TKvFMtyfLMdinGHhEE55gvvE0dlRe27Yd2vTLjfkGP5u8+gjd3rgix9Wg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] unexport ide_dma_on
Date: Fri, 1 Feb 2008 22:49:25 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20080128220844.GG8767@does.not.exist>
In-Reply-To: <20080128220844.GG8767@does.not.exist>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802012249.26067.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 January 2008, Adrian Bunk wrote:
> ide_dma_on can be unexported.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

applied
