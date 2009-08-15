Return-Path: <linux-kernel-owner+w=401wt.eu-S1751648AbZHOJLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbZHOJLp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 05:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbZHOJLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 05:11:45 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:58867 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbZHOJLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 05:11:44 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "H Hartley Sweeten" <hartleys@visionengravers.com>
Subject: Re: [PATCH] dc395x.h: use bitops.h BIT macro
Date: Sat, 15 Aug 2009 11:11:50 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.29-9-default; KDE/4.1.3; x86_64; ; )
Cc: "kernel list" <linux-kernel@vger.kernel.org>, aliakc@web.de,
       lenehan@twibble.org
References: <BD79186B4FD85F4B8E60E381CAEE190901BE9F54@mi8nycmail19.Mi8.com>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901BE9F54@mi8nycmail19.Mi8.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908151111.51951.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 15 August 2009 00:41:46 schrieb H Hartley Sweeten:
> Use BIT macro from linux/bitops.h instead of custom defines.

The patch looks good to me. You'll have to post it to the
scsi list.

	Regards
		Oliver
