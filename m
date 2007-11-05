Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbXKEUjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbXKEUjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 15:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbXKEUjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 15:39:33 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:34608 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbXKEUjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 15:39:32 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] usb/serial/oti6858.c: cleanups
Date: Mon, 5 Nov 2007 21:40:43 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: gregkh@suse.de, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <20071105170757.GY12045@stusta.de>
In-Reply-To: <20071105170757.GY12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711052140.44505.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 05 November 2007 schrieb Adrian Bunk:
> This patch containsthe following cleanups:
> - make the needlessly global send_data() static
> - an author without anemail address is OK, not a FIXME

That should be up to the author. If he thinks it should be there it might
be worth a FIXME

> - directly put the IDs into the id_table

Why?

> - remove the now-empty oti6858.h
> - kill the pointless driver version number

Why? There might be a new version in the future. If the author put
it there he might have had his reasons.

	Regards
		Oliver


