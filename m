Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbYAPBoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbYAPBoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 20:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbYAPBop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 20:44:45 -0500
Received: from smtp-out.google.com ([216.239.45.13]:56737 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbYAPBoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 20:44:44 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=JlTyjGsrhTP0NdYdU1LNgSvj6Hc1o1GxTE044o6BKkx09aDnK7x5K+0wSxPb5NRVC
	5yAIybLLpnGhu8bBuyb3w==
Message-ID: <4d47a5d10801151744t378ecdcbj1c326181b4360452@mail.gmail.com>
Date: Tue, 15 Jan 2008 20:44:38 -0500
From: "Daniel Phillips" <phillips@google.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental fsck)
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Theodore Tso" <tytso@mit.edu>,
       "Al Boldi" <a1426z@gawab.com>, "Valerie Henson" <val.henson@gmail.com>,
       "Rik van Riel" <riel@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080115201653.GA5639@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200801090022.55589.a1426z@gawab.com>
	 <200801090740.12989.a1426z@gawab.com>
	 <70b6f0bf0801082345vf57951ey642e35c3d6e5194f@mail.gmail.com>
	 <200801091452.14890.a1426z@gawab.com> <20080112145140.GB6751@mit.edu>
	 <20080113171916.GB4132@ucw.cz>
	 <20080113174125.5f39ac64@lxorguk.ukuu.org.uk>
	 <20080115201653.GA5639@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

Along with this effort, could you let me know if the world actually
cares about online fsck?  Now we know how to do it I think, but is it
worth the effort.

Regards,

Daniel
