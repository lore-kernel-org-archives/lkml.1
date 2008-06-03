Return-Path: <linux-kernel-owner+w=401wt.eu-S1756952AbYFCVn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952AbYFCVn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 17:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYFCVnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 17:43:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59842 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbYFCVnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 17:43:51 -0400
Message-ID: <4845BB0A.1040007@zytor.com>
Date: Tue, 03 Jun 2008 14:43:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: move bugs_64.c to cpu/bugs_64.c
References: <4845A42F.5050505@ct.jp.nec.com>
In-Reply-To: <4845A42F.5050505@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi Shimamoto wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> It looks good to move bugs_64.c to cpu/bugs_64.c.

Indeed it does.  Applied; will push after compile test.

	-hpa
