Return-Path: <linux-kernel-owner+w=401wt.eu-S1760897AbYEBHx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760897AbYEBHx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 03:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbYEBHxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 03:53:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45574 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509AbYEBHxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 03:53:48 -0400
Date: Fri, 2 May 2008 10:00:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de, hpa@zytor.com
Subject: Re: [PATCH 1/2] x86_64: fix mm.txt documentation
Message-ID: <20080502080017.GP20451@one.firstfloor.org>
References: <1209635899-23018-1-git-send-email-jirislaby@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209635899-23018-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 11:58:18AM +0200, Jiri Slaby wrote:
> Commit 85eb69a16aab5a394ce043c2131319eae35e6493 introduced 512 MiB
> sized kernel and 1.5 GiB sized module space but omitted to change
> documentation properly. Fix that.
> 
> [Wasn't the hole intentional protection hole?]

Yes it was.

-Andi
