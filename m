Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbXK1Sto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbXK1Sto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 13:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbXK1Stg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 13:49:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:32788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbXK1Stg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 13:49:36 -0500
Date: Wed, 28 Nov 2007 13:49:31 -0500
From: Dave Jones <davej@redhat.com>
To: =?utf-8?B?5pet5Lic546L?= <wangeastsun@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: a questio about slab: double free detected in cache
Message-ID: <20071128184931.GE18686@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	=?utf-8?B?5pet5Lic546L?= <wangeastsun@gmail.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <733610bd0711272059s5ba0954g5f7bfa7cb0324e02@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <733610bd0711272059s5ba0954g5f7bfa7cb0324e02@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 12:59:47PM +0800, 旭东王 wrote:
 
 > The environment of a device  is as below:
 > 
 > kernel version is 2.6.14, it is OS distribution kernel Fedora 2. The
 > file system is ext3. The cpu type is arm9.

I doubt you'll find anyone who really cares about fixing bugs in
kernels over two years old unless you can repeat them on
current kernel versions.
 
	Dave

-- 
http://www.codemonkey.org.uk
