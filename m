Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbYDUSxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbYDUSxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 14:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbYDUSw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 14:52:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35989 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbYDUSw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 14:52:57 -0400
Subject: Re: [PATCH] Force remount read-only of jffs2 when the garbage
	collector dies
From: David Woodhouse <dwmw2@infradead.org>
To: Michael Trimarchi <trimarchimichael@yahoo.it>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <831534.91220.qm@web26206.mail.ukl.yahoo.com>
References: <831534.91220.qm@web26206.mail.ukl.yahoo.com>
Content-Type: text/plain
Date: Mon, 21 Apr 2008 19:52:51 +0100
Message-Id: <1208803971.9212.509.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-21 at 16:31 +0000, Michael Trimarchi wrote:
>       Inviato da Yahoo! Mail. 
> La casella di posta intelligente.
> http://it.docs.yahoo.com/mail/overview/index.html

NAK. The garbage collector is purely an optimisation; we don't need it
for read-write operation.

-- 
dwmw2

