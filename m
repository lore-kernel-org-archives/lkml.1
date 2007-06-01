Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbXFAW2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbXFAW2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbXFAW17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:27:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:12569 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbXFAW16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:27:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mv+QEbFTkdwCJz3uXhACMKXgwu1xlh59o0/y72ELMNxYAjkg0lIJHYYCEifMUAfJSAWjXJFkqjY7rmyzKUeEHAVUWqeVuqfbBk01IN+fB4qOapqCr/dnP7jyGR1jeYoG68BsHY6Kby4qqBNewJkTQ+10orrjFKIAYbvFj90fxzE=
Message-ID: <86802c440706011527u4503253fv2edbbf7dbe642f76@mail.gmail.com>
Date: Fri, 1 Jun 2007 15:27:58 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 2/3]i386: early init pgt for fix virtual addr in head.S
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Greg KH" <gregkh@suse.de>, "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Vivek Goyal" <vgoyal@in.ibm.com>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440706011456x24217d36t644497e5ab57bb15@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440705202219o21d11023od1018d253364bf5c@mail.gmail.com>
	 <m1ps4fzdq0.fsf@ebiederm.dsl.xmission.com>
	 <86802c440706011246n795ecabfke0dfd1a695ba5e5f@mail.gmail.com>
	 <m1wsynxvlb.fsf@ebiederm.dsl.xmission.com>
	 <86802c440706011456x24217d36t644497e5ab57bb15@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

your 4/30 patch set, 4/5/6 is in mainline already.

YH
