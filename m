Return-Path: <linux-kernel-owner+w=401wt.eu-S1760005AbYF2Cp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760005AbYF2Cp0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 22:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYF2CpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 22:45:18 -0400
Received: from gw.goop.org ([64.81.55.164]:51569 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbYF2CpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 22:45:17 -0400
Message-ID: <4866F739.6050204@goop.org>
Date: Sat, 28 Jun 2008 19:45:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <4866F6FE.9000503@goop.org>
In-Reply-To: <4866F6FE.9000503@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Yes, it's intended behaviour.  Filesystem IO syscalls are considered 
> "fast" and are interruptible.

Er, *un*interruptible.

    J
