Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031546Ab0B1INO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 03:13:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46107
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031518Ab0B1ING (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 03:13:06 -0500
Date: Sun, 28 Feb 2010 00:13:25 -0800 (PST)
Message-Id: <20100228.001325.115921798.davem@davemloft.net>
To: andrea.gelmini@gelma.net
Cc: linux-kernel@vger.kernel.org, isdn@linux-pingi.de
Subject: Re: [PATCH 51/66] drivers/isdn/i4l/isdn_concap.h: Checkpatch
 cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <1267289508-31031-52-git-send-email-andrea.gelmini@gelma.net>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
	<1267289508-31031-52-git-send-email-andrea.gelmini@gelma.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Gelmini <andrea.gelmini@gelma.net>
Date: Sat, 27 Feb 2010 17:51:32 +0100

> drivers/isdn/i4l/isdn_concap.h:1: WARNING: CVS style keyword markers, these will _not_ be updated
> drivers/isdn/i4l/isdn_concap.h:11: ERROR: "foo * bar" should be "foo *bar"
> drivers/isdn/i4l/isdn_concap.h:11: ERROR: space prohibited after that open parenthesis '('
> drivers/isdn/i4l/isdn_concap.h:11: ERROR: space prohibited before that close parenthesis ')'
> 
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>

Acked-by: David S. Miller <davem@davemloft.net>
