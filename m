Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbZEOS2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbZEOS2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbZEOS2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:28:44 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:37699 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753032AbZEOS2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:28:43 -0400
Date: Fri, 15 May 2009 14:01:45 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Robin Holt <holt@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 4/4] zone_reclaim_mode is always 0 by default
In-Reply-To: <20090515082836.F5B9.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0905151401040.26559@qirst.com>
References: <20090513152256.GM7601@sgi.com> <alpine.DEB.1.10.0905141602010.1381@qirst.com> <20090515082836.F5B9.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009, KOSAKI Motohiro wrote:

> How about this?

Rewiewed-by: Christoph Lameter <cl@linux-foundation.org>
