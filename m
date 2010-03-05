Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab0CEMrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 07:47:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:44068 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab0CEMrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 07:47:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=uHSXFCEY5bXq8aZ+KUgy+qe/SpLslQmYVzYTbFzeM6VxS20cCK2s3ZMYoIE3ftCXdw
         oaT+MIbRDm1cPqPSdoFCwp34UEKl+tM1tUPD/dAwUd76kcLSawxRcMnorEiATTB+lIAz
         eT86A/xTohK9aEibjiBW/mffSvW29w/GQiPAA=
MIME-Version: 1.0
In-Reply-To: <20100305062002.GV8653@laptop>
References: <alpine.DEB.2.00.1002240949140.26771@router.home>
	 <alpine.DEB.2.00.1002242357450.26099@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1002251228140.18861@router.home>
	 <20100226114136.GA16335@basil.fritz.box>
	 <alpine.DEB.2.00.1002260904311.6641@router.home>
	 <20100226155755.GE16335@basil.fritz.box>
	 <alpine.DEB.2.00.1002261123520.7719@router.home>
	 <alpine.DEB.2.00.1002261555030.32111@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1003010224170.26824@chino.kir.corp.google.com>
	 <20100305062002.GV8653@laptop>
Date: Fri, 5 Mar 2010 14:47:04 +0200
Message-ID: <c1fb08351003050447w17175bbdy15e1e9bb78c2e40@mail.gmail.com>
Subject: Re: [patch] slab: add memory hotplug support
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Nick Piggin <npiggin@suse.de>
Cc: David Rientjes <rientjes@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, "haicheng.li" <haicheng.li@intel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dumb question: it is possible to hot remove the (bad) memory ? And add
an good one ?
Where is the detection code for the bad module ?
