Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbZJ1Ox2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbZJ1Ox2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 10:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbZJ1Ox1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 10:53:27 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:44213 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbZJ1Ox0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 10:53:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mssvcc6xSgyJQC7Nwr7F0epWKy5NWELvtO9aAgGidU+MeGyA5wwE2UUtdqX0prx7BV
         M4zpqaaEod6rccgQgHPukhyiO4ydfzM5RWFVnAMSFjKoIx3k1uiSjEqcS/IwuO1xQ1L2
         BBwxZdUqHb3nX5C0seeau2ZAX+2+3B5XHRGBU=
Date: Wed, 28 Oct 2009 17:53:25 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linux-numa@vger.kernel.org,
       Len Brown <lenb@kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch -mm] acpi: remove NID_INVAL
Message-ID: <20091028145325.GA5316@lenovo>
References: <20091008162454.23192.91832.sendpatchset@localhost.localdomain> <20091008162533.23192.71981.sendpatchset@localhost.localdomain> <alpine.DEB.1.10.0910081616040.8030@gentwo.org> <alpine.DEB.1.00.0910081325200.6998@chino.kir.corp.google.com> <alpine.DEB.2.00.0910271442250.30270@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910271442250.30270@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[David Rientjes - Tue, Oct 27, 2009 at 02:44:14PM -0700]
| NUMA_NO_NODE has been exported globally and thus it can replace NID_INVAL
| in the acpi code.
| 
| Also removes the unused acpi_unmap_pxm_to_node() function.
| 
| Cc: Len Brown <lenb@kernel.org>
| Cc: Cyrill Gorcunov <gorcunov@openvz.org>
| Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
| Signed-off-by: David Rientjes <rientjes@google.com>
| ---
|  Depends on Lee Schermerhorn's hugetlb patchset in mmotm-10132113.
| 

Thanks David! My Ack if needed.

	-- Cyrill
