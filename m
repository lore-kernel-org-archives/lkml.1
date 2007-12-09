Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbXLIRLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbXLIRLm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 12:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512AbXLIRLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 12:11:33 -0500
Received: from charlieb.ott.istop.com ([66.11.174.133]:55755 "HELO
	charlieb.ott.istop.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751075AbXLIRLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 12:11:32 -0500
Date: Sun, 9 Dec 2007 12:04:48 -0500 (EST)
From: Charlie Brady <charlieb@budge.apana.org.au>
X-X-Sender: charlieb@e-smith.charlieb.ott.istop.com
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
cc: linux-ppp@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PPP synchronous tty: convert dead_sem to completion
In-Reply-To: <20071208150954.GA8467@traven>
Message-ID: <Pine.LNX.4.64.0712091203490.976@e-smith.charlieb.ott.istop.com>
References: <20071208150954.GA8467@traven>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 8 Dec 2007, Matthias Kaehlcke wrote:

> PPP synchronous tty channel driver: convert the semaphore dead_sem to
> a completion
>
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Excuse my ignorance please, but why is this a good idea? Should we not 
record the reason for changes?
