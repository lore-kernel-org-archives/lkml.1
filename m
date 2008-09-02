Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbYIBQPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbYIBQPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 12:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbYIBQPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 12:15:00 -0400
Received: from smtp04.osg.ufl.edu ([128.227.74.71]:38524 "EHLO smtp.ufl.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751236AbYIBQO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 12:14:59 -0400
Message-ID: <1759827749.278411220372073312.JavaMail.osg@osgjas03.cns.ufl.edu>
Date: Tue, 2 Sep 2008 12:14:33 -0400 (EDT)
From: "CHADHA,VINEET" <vineet@ufl.edu>
To: Arjan van de Ven <arjan@infradead.org>, "CHADHA,VINEET" <vineet@ufl.edu>
Subject: Re: TLB evaluation for Linux
Cc: nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Mailer: GatorMail WebMail (http://GatorMail.sf.net/)
X-Originating-IP: 10.5.149.137 [10.5.149.137]
X-UFL-Spam-Status: hits=-2.5, required=5, tests=ALL_TRUSTED,TW_VL
X-UFL-Scanned-By: CNS Open Systems Group (http://open-systems.ufl.edu/services/smtp-relay/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I don't have a reference, but I'd not be surprised to see on 
> virtual
> machines for this to be even stronger; each invlpg would be a
> hypercall, compared to only one for the total flush.
> 

I agree that overhead could be more in virtual machines. Questions 
is that does VMs
are designed with evaluation of performance issues at 
micro-architetural level. Is this the best design for virtual 
machines or Linux ?

I don't see many numbers or published paper to make a claim.

Regards,
Vineet


