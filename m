Return-Path: <linux-kernel-owner+w=401wt.eu-S1763482AbYDVTDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763482AbYDVTDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbYDVTDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:03:41 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60809 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678AbYDVTDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:03:40 -0400
Date: Tue, 22 Apr 2008 21:03:39 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Sanjeev Aditya Naga <sanjeev.kernel@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: config file part of kernel!
In-Reply-To: <5681ec900804220953g187b792eib424c7af4cd3df4f@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0804222103240.13697@fbirervta.pbzchgretzou.qr>
References: <5681ec900804220953g187b792eib424c7af4cd3df4f@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-04-22 18:53, Sanjeev Aditya Naga wrote:
>
>Will it be good, if we make the `config` file (used to
>build a kernel) part of the built kernel. So that one in
>need, can extract it from the kernel using some
>userspace tool!?

Surprise, what do you think /proc/config.gz is for? :-)
