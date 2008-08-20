Return-Path: <linux-kernel-owner+w=401wt.eu-S1758745AbYHTP15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745AbYHTP15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 11:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYHTP1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 11:27:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751937AbYHTP1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 11:27:47 -0400
Message-ID: <48AC37E3.1050803@linux-foundation.org>
Date: Wed, 20 Aug 2008 10:27:31 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       tokunaga.keiich@jp.fujitsu.com
Subject: Re: [RFC][PATCH 2/2] quicklist shouldn't be proportional to # of
 CPUs
References: <20080820195021.12E7.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080820200709.12F0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080820200709.12F0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good.

Acked-by: Christoph Lameter <cl@linux-foundation.org>
