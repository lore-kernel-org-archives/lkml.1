Return-Path: <linux-kernel-owner+w=401wt.eu-S1759916AbYDNHTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759916AbYDNHTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 03:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755966AbYDNHS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 03:18:56 -0400
Received: from mail.hevs.ch ([153.109.23.10]:57019 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973AbYDNHSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 03:18:55 -0400
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: Michael Trimarchi <trimarchimichael@yahoo.it>
Subject: Re: [PATCH] atmel_serial remove duplicated macro definition
Date: Mon, 14 Apr 2008 09:18:52 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>
References: <370563.4572.qm@web26213.mail.ukl.yahoo.com>
In-Reply-To: <370563.4572.qm@web26213.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804140918.53612.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2008, Michael Trimarchi wrote:
> After commit 39d4c922b596633da86878b1a5cc881785b8e5fa (atmel_serial: fix
> uart/console concurrent access) the UART_GET_TCR macro got redefined. This
> patch removes the duplicated definition.
>
Ooops, seems my error!

ack

Regards

Marc

