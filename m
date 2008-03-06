Return-Path: <linux-kernel-owner+w=401wt.eu-S1758955AbYCFEsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbYCFEsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 23:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757148AbYCFEsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 23:48:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38753
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754178AbYCFEsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 23:48:03 -0500
Date: Wed, 05 Mar 2008 20:47:57 -0800 (PST)
Message-Id: <20080305.204757.13821992.davem@davemloft.net>
To: harvey.harrison@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: replace remaining __FUNCTION__ occurrences
From: David Miller <davem@davemloft.net>
In-Reply-To: <1204773069.14154.58.camel@brick>
References: <1204575406.3266.55.camel@brick>
	<20080305.185815.179794444.davem@davemloft.net>
	<1204773069.14154.58.camel@brick>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Wed, 05 Mar 2008 19:11:09 -0800

> __FUNCTION__ is gcc-specific, use __func__
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Applied, thanks Harvey.
