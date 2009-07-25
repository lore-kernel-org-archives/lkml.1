Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbZGYNfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbZGYNfP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 09:35:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZGYNfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 09:35:14 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:50628 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751794AbZGYNfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 09:35:13 -0400
From: Frans Pop <elendil@planet.nl>
To: Arnaud Faucher <arnaud.faucher@gmail.com>
Subject: Re: [PATCH] serial: 8250: switch to dev_pm_ops
Date: Sat, 25 Jul 2009 15:35:10 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, arnaud.faucher@gmail.com
References: <1248524235-11167-1-git-send-email-arnaud.faucher@gmail.com>
In-reply-To: <1248524235-11167-1-git-send-email-arnaud.faucher@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907251535.11573.elendil@planet.nl>
X-OriginalArrivalTime: 25 Jul 2009 13:35:12.0104 (UTC) FILETIME=[BC38C680:01CA0D2C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaud Faucher wrote:
> Signed-off-by: Arnaud Faucher <arnaud.faucher@gmail.com>
> ---
>  drivers/serial/8250.c |   16 ++++++++++------
>  1 files changed, 10 insertions(+), 6 deletions(-)

The same patch has already been proposed in 
http://lkml.org/lkml/2009/7/1/44.

Cheers,
FJP
