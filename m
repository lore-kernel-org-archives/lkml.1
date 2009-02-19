Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbZBSEzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbZBSEzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 23:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbZBSEzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 23:55:04 -0500
Received: from smtp-out.hotpop.com ([38.113.3.51]:40354 "EHLO
	smtp-out.hotpop.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbZBSEzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 23:55:01 -0500
Date: Thu, 19 Feb 2009 05:51:00 +0100
From: John Werden <jwerden@hotpop.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] SCHED_IDLE makes system unresponsive
Message-ID: <20090219055100.3fe4b0ce@desktop.workplace>
In-Reply-To: <1234853211.5507.42.camel@marge.simson.net>
References: <20090216205535.1a1eafe0@desktop.workplace>
	<1234853211.5507.42.camel@marge.simson.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-HotPOP: -----------------------------------------------
                   Sent By HotPOP.com FREE Email
             Get your FREE POP email at www.HotPOP.com
          -----------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Feb 2009 07:46:51 +0100
Mike Galbraith <efault@gmx.de> wrote:

> 
> If you need to use SCHED_IDLE in 28-stable, you'll want the below.
> 

Thank you, that fixed the problem.

John

