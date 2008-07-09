Return-Path: <linux-kernel-owner+w=401wt.eu-S1757058AbYGIIbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058AbYGIIbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 04:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbYGIIbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 04:31:37 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:50036 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbYGIIbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 04:31:36 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: 2.6.25: random stalls on certain hardware - regression?
Date: Wed, 9 Jul 2008 10:32:14 +0200
User-Agent: KMail/1.9.9
Cc: "Linux-kernel" <linux-kernel@vger.kernel.org>
References: <4873E27C.6050504@msgid.tls.msk.ru>
In-Reply-To: <4873E27C.6050504@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807091032.14786.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 08 Juli 2008 23:56:12 schrieb Michael Tokarev:

> Any idea how to start welcome.  Meanwhile I'll try current 2.6.26pre,
> in a hope it will not destroy all our data.. ;)

Can you test whether select() triggers the lockup?

	Regards
		Oliver

