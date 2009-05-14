Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbZENTwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbZENTwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 15:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbZENTwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 15:52:33 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:60515 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753342AbZENTwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 15:52:33 -0400
Date: Thu, 14 May 2009 15:52:27 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/4] vmscan: change the number of the unmapped files in
 zone reclaim
In-Reply-To: <20090513120606.587C.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0905141551390.1381@qirst.com>
References: <20090513120155.5879.A69D9226@jp.fujitsu.com> <20090513120606.587C.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Yup, the use of NR_FILE_PAGES there predates the INACTIVE/ACTIVE stats.

Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

