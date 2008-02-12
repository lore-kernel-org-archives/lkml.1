Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbYBLD5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbYBLD5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 22:57:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbYBLD5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 22:57:41 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:28930 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbYBLD5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 22:57:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Hk0a16sUKdxzVDpjdt9ZpgAtX33DRzJbZ76ytLp6AntgmRNkJlD3v3BzYC1XHRUkqeN8VYpeNuC1zzRS7whj1CWgtTEqQbjqDBJq1VcCNinmSpqrqaUJW9o6GRu9w/jbGlRBTfEG6bdMX3MK9jW6c9IP+p4p6r30VcgKu0kseb0=
Message-ID: <a44ae5cd0802111957mf196288m1fe5fd4219911336@mail.gmail.com>
Date: Mon, 11 Feb 2008 22:57:39 -0500
From: "Miles Lane" <miles.lane@gmail.com>
To: "Nishanth Aravamudan" <nacc@us.ibm.com>
Subject: Re: 2.6.24-git20 -- BUG: sleeping function called from invalid context at include/asm/uaccess_32.h:449
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Adam Litke" <agl@us.ibm.com>,
       "David Gibson" <david@gibson.dropbear.id.au>
In-Reply-To: <20080211222855.GA9138@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0802091103s4c24c70fyc747d9c4ab9a9897@mail.gmail.com>
	 <20080209162643.fd3822f1.akpm@linux-foundation.org>
	 <20080210212528.GA17442@us.ibm.com> <20080211222855.GA9138@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excellent.  Your patch fixed it for me.

Thanks,
        Miles
