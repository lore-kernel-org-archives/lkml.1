Return-Path: <linux-kernel-owner+w=401wt.eu-S1761495AbZDAPgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761495AbZDAPgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 11:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbZDAPgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 11:36:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50305 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbZDAPgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 11:36:05 -0400
Message-ID: <49D38967.8020706@redhat.com>
Date: Wed, 01 Apr 2009 11:33:59 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, frankeh@watson.ibm.com, akpm@osdl.org,
       nickpiggin@yahoo.com.au, hugh@veritas.com
Subject: Re: [patch 5/6] Guest page hinting: minor fault optimization.
References: <20090327150905.819861420@de.ibm.com> <20090327151012.713478499@de.ibm.com>
In-Reply-To: <20090327151012.713478499@de.ibm.com>
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
> On of the challenges of the guest page hinting scheme is the cost for
> the state transitions. If the cost gets too high the whole concept of
> page state information is in question. Therefore it is important to
> avoid the state transitions when possible. 

> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
