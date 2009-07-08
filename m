Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbZGHCRC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbZGHCRC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 22:17:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757336AbZGHCQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 22:16:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:52328 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755848AbZGHCQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 22:16:53 -0400
Message-ID: <4A540173.4070301@kernel.org>
Date: Wed, 08 Jul 2009 11:16:19 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Figo.zhang" <figo1802@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH v2] vmalloc.c: fix double error checking
References: <1246983201.2597.13.camel@myhost> <1247019117.2573.3.camel@myhost>
In-Reply-To: <1247019117.2573.3.camel@myhost>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Jul 2009 02:16:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Figo.zhang wrote:
> it is no need for double error checking.
> 
> in v2, if vmap_pud_ranger() error, directly return err. 
> 
> Signed-off-by: Figo.zhang <figo1802@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
