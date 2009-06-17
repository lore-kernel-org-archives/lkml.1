Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbZFQP34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbZFQP34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 11:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbZFQP3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 11:29:44 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:53534 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066AbZFQP3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 11:29:43 -0400
Date: Wed, 17 Jun 2009 19:29:43 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Richard Henderson <rth7680@gmail.com>
Cc: john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-alpha@vger.kernel.org
Subject: Re: [PATCH] Convert alpha to use arch_gettimeoffset()
Message-ID: <20090617152943.GB17720@jurassic.park.msu.ru>
References: <1244758210.7192.5.camel@localhost.localdomain> <4A31FDBE.3030506@gmail.com> <1244832112.7231.3.camel@localhost.localdomain> <4A37DA2C.8020106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A37DA2C.8020106@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 10:45:16AM -0700, Richard Henderson wrote:
> Unfortunately I don't have working hardware anymore.  Perhaps Ivan will be 
> able to help here.

I can give it a try next week (I'm away from hardware currently).

Ivan.
