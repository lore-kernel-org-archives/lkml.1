Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000AbXCZRIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbXCZRIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 13:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbXCZRIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 13:08:05 -0400
Received: from il.qumranet.com ([82.166.9.18]:57094 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbXCZRIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 13:08:02 -0400
Message-ID: <4607FDEF.5010709@qumranet.com>
Date: Mon, 26 Mar 2007 19:07:59 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Yaniv Kamay <yaniv@qumranet.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] drivers/kvm/svm.c remove unused function
References: <46069C64.6020105@googlemail.com>
In-Reply-To: <46069C64.6020105@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski wrote:
> Remove unused function
>
> CC      drivers/kvm/svm.o
> drivers/kvm/svm.c:207: warning: ‘inject_db’ defined but not used
>   

Applied, thanks.


-- 
error compiling committee.c: too many arguments to function

