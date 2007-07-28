Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbXG1Xo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbXG1Xo5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 19:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758090AbXG1Xoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 19:44:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:55347 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758067AbXG1Xop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 19:44:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ql8PyB2mtNbKFEJ8lrZA7g7yqhkzoD2Vg6o8yh16yEODoUAKZMSbDOMcNtV+cjSEQYG57HwkBA0fpoAG7j9pPqjLYHK1bmzoYJXxmoDf2D1SqRU81ni/bakPOdZNicXdf+z678p+V8RsGfRqnfz7GmEMLax2DneuNLgdIfC6C8Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Lamparter <lists@diac24.net>
Subject: Re: [PATCH] ide: sis5513.c: Add FSC Amilo A1630 PCI subvendor/dev to laptops
Date: Sun, 29 Jul 2007 00:55:19 +0200
User-Agent: KMail/1.9.6
Cc: Lionel Bouton <Lionel.Bouton@inet6.fr>, linux-kernel@vger.kernel.org
References: <20070727205242.GA1216@charon.n2.diac24.net>
In-Reply-To: <20070727205242.GA1216@charon.n2.diac24.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707290055.19816.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 July 2007, David Lamparter wrote:
> [PATCH] ide: sis5513.c: Add FSC Amilo A1630 PCI subvendor/dev to laptops
> 
> Recognise the FSC Amilo A1630's incarnation of a SiS5513 chip as laptop to
> get UDMA100 support.
> 
> Signed-off-by: David Lamparter <equinox@diac24.net>

applied, thanks
