Return-Path: <linux-kernel-owner+w=401wt.eu-S937491AbYBWIjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937491AbYBWIjZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937297AbYBWI2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:28:03 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39091 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937330AbYBWI2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:28:00 -0500
Date: Sat, 23 Feb 2008 17:18:21 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] ResCounter: Use read_uint in memory controller
Cc: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       menage@google.com, xemul@openvz.org, balbir@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20080223000426.adf5c75a.akpm@linux-foundation.org>
References: <47BE4FB5.5040902@linux.vnet.ibm.com> <20080223000426.adf5c75a.akpm@linux-foundation.org>
Message-Id: <20080223171647.AE7E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

> yup, I agree.  Even though I don't know what ILP32 and LP64 are ;)

ILP32: integer and long and pointer size is 32bit
LP64:  long and pointer size is 64bit, but int size is 32bit

linux 32bit kernel obey ILP32 model, 64bit kernel obey LP64.

Thanks.


- kosaki

