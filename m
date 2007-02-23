Return-Path: <linux-kernel-owner+w=401wt.eu-S932470AbXBWUDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbXBWUDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 15:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932654AbXBWUDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 15:03:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:14525 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932470AbXBWUDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 15:03:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=IRtDlLCYr+jcvrjptK3ifQDr6Mks3m8zM4/RZex68dHrZpcwT/5podEODrXOweDB2gmEnUUwg4J8m7AsIDbGxt3L4eUkBBh08iXlW9AvbRmThN9XsA0z/jV80SNQ8yoyAFeTnrymsSnvJ2IyaTWpULyMINDr+9U73bsTbW/Cm40=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] ide: remove a ton of pointless #undef REALLY_SLOW_IO
Date: Fri, 23 Feb 2007 21:09:34 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <20070220175401.4d45891e@localhost.localdomain>
In-Reply-To: <20070220175401.4d45891e@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702232109.34873.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 20 February 2007, Alan wrote:
> Signed-off-by: Alan Cox <alan@redhat.com>

applied
