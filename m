Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbZAEWHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbZAEWHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 17:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbZAEWHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:07:33 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:29200 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbZAEWHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:07:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ueyhzltNoca9e43Zee7f87YI6k+PmS5c3hYQM45rgStHOkK/T4UK+9iErw0+RogdpX
         ocdNKZeDuW4rimSobqsRoZuxEYjLN+4nDxxw5ckz1jON0p74RFN3ffUWh8Vg98ZPJrVQ
         pIKb454aiHdoAxz2eBfLDTmokz/20PvZ025s4=
Message-ID: <86802c440901051407ib7e69fey527dcce77cd2a461@mail.gmail.com>
Date: Mon, 5 Jan 2009 14:07:30 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: david@lang.hm, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: early exception error
Cc: "Cyrill Gorcunov" <gorcunov@gmail.com>, "Jiri Slaby" <jirislaby@gmail.com>,
       "Andi Kleen" <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440901051355o60bef5bai2a33ea5f7e4dc5f7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090102174845.GD5372@localhost>
	 <alpine.DEB.1.10.0901030823190.23262@asgard.lang.hm>
	 <20090103161052.GB11093@localhost>
	 <alpine.DEB.1.10.0901031118450.23262@asgard.lang.hm>
	 <20090103190316.GB7367@localhost> <20090103212426.GC7367@localhost>
	 <496001A3.1040201@gmail.com> <20090104112919.GC7632@localhost>
	 <alpine.DEB.1.10.0901051420030.27641@asgard.lang.hm>
	 <86802c440901051355o60bef5bai2a33ea5f7e4dc5f7@mail.gmail.com>
X-Google-Sender-Auth: f7dead08838198c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

can you make sure X86_64_APCI_NUMA is set?

# CONFIG_X86_64_ACPI_NUMA is not set

YH
