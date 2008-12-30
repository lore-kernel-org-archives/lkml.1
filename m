Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbYL3EQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbYL3EQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 23:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbYL3EQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 23:16:02 -0500
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:47161 "EHLO
	QMTA08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751639AbYL3EQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 23:16:00 -0500
From: Dmitry Torokhov <dtor@mail.ru>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Input: atkbd - broaden the Dell DMI signatures
Date: Mon, 29 Dec 2008 20:15:33 -0800
User-Agent: KMail/1.10.3 (Linux/2.6.27.9-159.fc10.x86_64; KDE/4.1.3; x86_64; ; )
Cc: Nick Warne <nick@ukfsn.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
References: <20081111074702.75e71055@sauron.linicks.net> <20081229113621.1a64caea@sauron.linicks.net> <20081229142902.GC31266@srcf.ucam.org>
In-Reply-To: <20081229142902.GC31266@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812292015.34296.dtor@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 December 2008 06:29:02 Matthew Garrett wrote:
> Some Dells need the dell input quirk applied but have a different vendor
> string in their DMI tables. Add an extra entry to cover these machines as
> well.
>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
>
> ---
>
> Dmitry, any chance of getting this queued for .29? Probably suitable for
> -stable as well.

Yep, will send with the rest of stuff for .29. Thank you Matthew.

-- 
Dmitry
