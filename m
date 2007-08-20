Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbXHTIqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbXHTIqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 04:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbXHTIp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 04:45:58 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:48666 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751450AbXHTIp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 04:45:58 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: HTC as USB gprs/edge modem on linux
Date: Mon, 20 Aug 2007 10:45:54 +0200
User-Agent: KMail/1.9.7
Cc: bizu <bizu@burlesk.fr>, linux-kernel@vger.kernel.org
References: <c929dccd5f4f0fec6ad55e93caafae43@127.0.0.1> <46C8BFAF.50604@googlemail.com>
In-Reply-To: <46C8BFAF.50604@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708201045.54301.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 20 August 2007 schrieb Michal Piotrowski:
> This patch (against 2.6.23-rc3-git2) disables auto-suspend for this device.

Why would you want that? Not every log that has "autosuspend" in it
is a power management quirk. These devices simply need a patch to
be recognised as rndis devices.

	Regards
		Oliver

