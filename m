Return-Path: <linux-kernel-owner+w=401wt.eu-S1760187AbYB0XDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187AbYB0XDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755506AbYB0XDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:03:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:26015 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbYB0XDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:03:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=AIr6YYA/2bWcm4pi14kW+GLODbOMbQF7JcZyvoH7xXTlHaZDbACMDRNPSdjFMogAZpoeG9S28V+z4v2w4iHQla3qW8IMxJrIPlkz8lR7mfyRCrmsuhVBvOPpIpyAvbG4NgJqvAR0ClMUbrtZVjd9k9IMd6gzjPt9HfPnMjl98yw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 4/5] ide-cd: shorten lines longer than 80 columns
Date: Thu, 28 Feb 2008 00:15:27 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1204136449-9490-1-git-send-email-petkovbb@gmail.com> <20080227221532.GB9545@gollum.tnic> <200802280001.43316.bzolnier@gmail.com>
In-Reply-To: <200802280001.43316.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802280015.27990.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 February 2008, Bartlomiej Zolnierkiewicz wrote:

[...]

> [ IOW We are putting way too much time into these coding style fixes and as
>   the old code is replaced with the new one the coding style improves itself. ]

Just to clarify: by "these" I meant only ide-cd ones, i.e. we are beautifying
comments for code which is going to be heavily modified soon because of other
changes like ATAPI handling unification...
