Return-Path: <linux-kernel-owner+w=401wt.eu-S939094AbXGSQnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939094AbXGSQnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933233AbXGSQnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:43:06 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60942 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760462AbXGSQnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:43:05 -0400
Date: Thu, 19 Jul 2007 18:43:04 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andi Kleen <ak@suse.de>
cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [8/58] x86_64: Use string instruction memcpy/memset on
 AMD Fam10
In-Reply-To: <20070719095452.4419E14E04@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0707191841220.31013@fbirervta.pbzchgretzou.qr>
References: <200707191154.642492000@suse.de> <20070719095452.4419E14E04@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 19 2007 11:54, Andi Kleen wrote:

>Subject: [PATCH] [8/58] x86_64: Use string instruction memcpy/memset on AMD
>    Fam10

What processors carry 0x10?



	Jan
-- 
