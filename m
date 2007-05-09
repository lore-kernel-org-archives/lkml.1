Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbXEII7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbXEII7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:59:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbXEII7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 04:59:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:48826 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbXEII7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 04:59:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=dQ3zUOO4/fcRv3OCU/0ieHxb6nDdxSjrGq+fg5SwoiVA2fnkXInHAiuszwrSeYX6q5EJVnNfmOLEgAqe4mWJOA1eSfpL8fEtRHaOSXzanlurGMAdmUOFlFFAa3niPKv+To5F4J9pLQQte2KDR3ru2Sx6VlD7d3DzwvCQJH8DXgo=
Message-ID: <84144f020705090159t72ea1bd8qccc60791f3be8db@mail.gmail.com>
Date: Wed, 9 May 2007 11:59:33 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: CodingStyle: start flamewar about use of braces
Cc: "Satyam Sharma" <satyam.sharma@gmail.com>, "Jeff Garzik" <jeff@garzik.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <4641836C.200@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705081903.l48J3AOw010373@hera.kernel.org>
	 <20070508124301.17975a4f.randy.dunlap@oracle.com>
	 <4640E971.9050400@garzik.org>
	 <a781481a0705081637x129cb009u6a557205d3776014@mail.gmail.com>
	 <4641836C.200@s5r6.in-berlin.de>
X-Google-Sender-Auth: 8bba01b839967778
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> I don't know which form is better suited to the goal of well
> maintainable code --- the compact, easy to read, winning guideline, or
> the comprehensive norm.

Bah, it's a slippery slope. Too little guidelines and we end up people
submitting code that is "obviously" violating Linux coding standards
on the basis of that it's not forbidden by Documentation/CodingStyle.
And with too much detail, we end up with something that nobody wants
to read let alone follow. So what CodingStyle should say, really, is
that maintainers have different preference and you're usually better
off following them than fighting against them ;-).
