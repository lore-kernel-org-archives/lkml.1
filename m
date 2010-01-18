Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543Ab0AREDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab0AREDN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 23:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324Ab0AREDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 23:03:10 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:47436 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab0AREDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 23:03:09 -0500
Date: Mon, 18 Jan 2010 13:02:53 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Matt Fleming <matt@console-pimps.org>,
       Francesco Virlinzi <francesco.virlinzi@st.com>,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/sh: Fix build failure caused by missing semicolon / missing include
Message-ID: <20100118040253.GA13854@linux-sh.org>
References: <201001180357.31594.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001180357.31594.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 03:57:31AM +0100, Peter Huewe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> Date: Mon, 18 Jan 2010 03:48:31 +0100
> 
> This patch fixes a build failure[1][2] for all sh configs, by fixing a
> missing semicolon and a missing include file.
> 
> Build failure was introduced by the patch
> 	sh: fixed PMB mode refactoring [3]
> 	of Wed, 13 Jan 2010 09:31:48 +0000 (18:31 +0900)
> 
This was already caught and corrected, thanks anyways.
