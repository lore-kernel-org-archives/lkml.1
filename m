Return-Path: <linux-kernel-owner+w=401wt.eu-S1760191AbYCCTmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191AbYCCTmv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 14:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbYCCTml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 14:42:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36808
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752740AbYCCTmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 14:42:40 -0500
Date: Mon, 03 Mar 2008 11:42:24 -0800 (PST)
Message-Id: <20080303.114224.38374241.davem@davemloft.net>
To: harvey.harrison@gmail.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc64: replace remaining __FUNCTION__ occurances
From: David Miller <davem@davemloft.net>
In-Reply-To: <1204572481.3266.44.camel@brick>
References: <1204572481.3266.44.camel@brick>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Mon, 03 Mar 2008 11:28:01 -0800

> __FUNCTION__ is gcc-specific, use __func__
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Applied, thanks.
