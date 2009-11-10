Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbZKJV1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbZKJV1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbZKJV1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:27:10 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:15373 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842AbZKJV1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:27:10 -0500
Date: Tue, 10 Nov 2009 14:26:29 -0700
From: Alex Chiang <achiang@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Badari Pulavarty <pbadari@us.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch -mm] mm: slab allocate memory section nodemask for
	large systems
Message-ID: <20091110212629.GD27861@ldl.fc.hp.com>
References: <alpine.DEB.2.00.0910221249030.26631@chino.kir.corp.google.com> <20091027195907.GJ14102@ldl.fc.hp.com> <alpine.DEB.2.00.0910271422090.22335@chino.kir.corp.google.com> <20091028083137.GA24140@osiris.boeblingen.de.ibm.com> <alpine.DEB.2.00.0910280159380.7122@chino.kir.corp.google.com> <20091028183905.GF22743@ldl.fc.hp.com> <alpine.DEB.2.00.0910281315370.23279@chino.kir.corp.google.com> <20091102204726.GG5525@ldl.fc.hp.com> <20091110125131.30376c03.akpm@linux-foundation.org> <alpine.DEB.2.00.0911101255020.28728@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0911101255020.28728@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Rientjes <rientjes@google.com>:
> On Tue, 10 Nov 2009, Andrew Morton wrote:
> 
> > The prerequisite Documentation/ patches are a bit of a mess - some have
> > been cherrypicked into Greg's tree I believe and some haven't.  So
> > please also send out whatever is needed to bring linux-next up to date.

Thanks, I'll respin.

> I'm not aware of any prerequisites for this patchset, Alex's documentation 
> changes have already been merged by Linus.

Correct. So I'll respin this series against... Linus's tree? Or
maybe mmotm? Please advise.

Thanks,
/ac

