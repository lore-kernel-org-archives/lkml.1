Return-Path: <linux-kernel-owner+w=401wt.eu-S1754446AbZDOTVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446AbZDOTVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 15:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbZDOTVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 15:21:39 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:47146 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbZDOTVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 15:21:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oTBc24Yx2IPVxMKrZmQO7CT+Ttc1ylEAmYzs+mHEOigJRKS2dB4wFPOxeR3IWQ0Rbd
         zpDDvKrup79D0BkDW/OGqpB8DN/UTubye1pYMATEOD8nxY/InMmLo7vxzIhn5yL7Bex+
         9qSOWgoyF9fH7CU+gPMQ4Co1yxmAdvl1NLaCs=
Date: Wed, 15 Apr 2009 23:21:50 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, Dave Hansen <dave@linux.vnet.ibm.com>,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, mingo@elte.hu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: CAP_SYS_ADMIN on restart(2) (was: Re: [PATCH 00/30] C/R
	OpenVZ/Virtuozzo style)
Message-ID: <20090415192150.GC26994@x200.localdomain>
References: <20090410023207.GA27788@x200.localdomain> <1239340031.24083.21.camel@nimitz> <20090413091423.GA19236@x200.localdomain> <49E4108A.8050201@cs.columbia.edu> <20090414145830.GA27461@x200.localdomain> <49E4D115.5080601@cs.columbia.edu> <20090414204912.GA28458@x200.localdomain> <20090414213934.GB17986@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414213934.GB17986@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is sysctl to control CAP_SYS_ADMIN on restart(2) OK?
