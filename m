Return-Path: <linux-kernel-owner+w=401wt.eu-S1762308AbZDAQUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762308AbZDAQUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbZDAQU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:20:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44709 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950AbZDAQU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:20:28 -0400
Message-ID: <49D393F2.2010105@redhat.com>
Date: Wed, 01 Apr 2009 12:18:58 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, frankeh@watson.ibm.com, akpm@osdl.org,
       nickpiggin@yahoo.com.au, hugh@veritas.com
Subject: Re: [patch 6/6] Guest page hinting: s390 support.
References: <20090327150905.819861420@de.ibm.com> <20090327151013.024372165@de.ibm.com>
In-Reply-To: <20090327151013.024372165@de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
> From: Hubertus Franke <frankeh@watson.ibm.com>
> From: Himanshu Raj
> 
> s390 uses the milli-coded ESSA instruction to set the page state. The
> page state is formed by four guest page states called block usage states
> and three host page states called block content states.

> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
