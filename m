Return-Path: <linux-kernel-owner+w=401wt.eu-S1759403AbZEFA6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759403AbZEFA6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 20:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758852AbZEFA61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 20:58:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58575 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476AbZEFA60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 20:58:26 -0400
Message-ID: <4A00DFFB.3050708@redhat.com>
Date: Tue, 05 May 2009 20:55:23 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Izik Eidus <ieidus@redhat.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       aarcange@redhat.com, chrisw@redhat.com, alan@lxorguk.ukuu.org.uk,
       device@lanana.org, linux-mm@kvack.org, hugh@veritas.com,
       nickpiggin@yahoo.com.au
Subject: Re: [PATCH 6/6] ksm: use another miscdevice minor number.
References: <1241475935-21162-1-git-send-email-ieidus@redhat.com> <1241475935-21162-2-git-send-email-ieidus@redhat.com> <1241475935-21162-3-git-send-email-ieidus@redhat.com> <1241475935-21162-4-git-send-email-ieidus@redhat.com> <1241475935-21162-5-git-send-email-ieidus@redhat.com> <1241475935-21162-6-git-send-email-ieidus@redhat.com> <1241475935-21162-7-git-send-email-ieidus@redhat.com>
In-Reply-To: <1241475935-21162-7-git-send-email-ieidus@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Izik Eidus wrote:
> The old number was registered already by another project.
> The new number is #234.
> 
> Thanks.
> 
> Signed-off-by: Izik Eidus <ieidus@redhat.com>
> Signed-off-by: Alan Cox <device@lanana.org>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
