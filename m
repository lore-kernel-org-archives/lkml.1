Return-Path: <linux-kernel-owner+w=401wt.eu-S1762662AbYEYMWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762662AbYEYMWK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 08:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757356AbYEYMV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 08:21:57 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:39808 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755905AbYEYMV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 08:21:57 -0400
Message-ID: <483959DD.8020505@davidnewall.com>
Date: Sun, 25 May 2008 21:51:49 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: devzero@web.de
CC: Shuduo Sang <sangshuduo@gmail.com>, bosko.radivojevic@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: Inserting code from userspace to kernel space
References: <290982711@web.de>
In-Reply-To: <290982711@web.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devzero@web.de wrote:
> this can be illegal, too.
>
> http://www.gnu.org/licenses/gpl-faq.html#ModifiedJustBinary
>   

I think what he's trying to achieve is an unmodified or modified but
fully GPL kernel plus a separate, proprietary binary to be loaded at
runtime.
