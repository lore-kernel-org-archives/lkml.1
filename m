Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbXKVQLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbXKVQLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 11:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbXKVQLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 11:11:35 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:33906 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbXKVQLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 11:11:34 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Subject: Re: Use of mutex in interrupt context flawed/impossible, need advice.
Date: Thu, 22 Nov 2007 17:11:38 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <c384c5ea0711220802i21e3df45q1d328aea63e7ebf4@mail.gmail.com>
In-Reply-To: <c384c5ea0711220802i21e3df45q1d328aea63e7ebf4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711221711.39134.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 22 November 2007 schrieb Leon Woestenberg:
> I would like to know why this is not so, and if someone has a cleaner
> proposal than the "try spinlock" approach?

Keep the semaphore.

	Regards
		Oliver

