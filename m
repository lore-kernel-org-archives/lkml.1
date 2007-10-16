Return-Path: <linux-kernel-owner+w=401wt.eu-S1765550AbXJPFET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765550AbXJPFET (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 01:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbXJPFEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 01:04:10 -0400
Received: from smtp-out.google.com ([216.239.45.13]:51088 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbXJPFEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 01:04:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=dcn+iDTRHM16ETRW98aqs0ik28QyBO/cz5QfTEsxwREahlVuNrK2C31pWOhI02RUr
	nIU5KebmsaEYHZcAYo4uw==
Date: Mon, 15 Oct 2007 22:03:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Matt Mackall <mpm@selenic.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dave Hansen <haveblue@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH 5/11] maps3: use pagewalker in clear_refs and smaps
In-Reply-To: <6.290135367@selenic.com>
Message-ID: <alpine.DEB.0.9999.0710152203020.9620@chino.kir.corp.google.com>
References: <6.290135367@selenic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Matt Mackall wrote:

> Use the generic pagewalker for smaps and clear_refs
> 
> Signed-off-by: Matt Mackall <mpm@selenic.com>

Acked-by: David Rientjes <rientjes@google.com>
