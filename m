Return-Path: <linux-kernel-owner+w=401wt.eu-S1758070AbYD2JQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbYD2JQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 05:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYD2JQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 05:16:20 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:36613 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbYD2JQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 05:16:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HhrqkKO9NyCtbfxqgRJMLxkd07p5xT/lSge1c5WFQATYabwvnRofYkQti/W+m/fPglxB/vNae6Dz179F9iP5+N0m+qgXUf2gibpAMPYpo2hO5oIEB42SQaj3SESuPGKvA9HEgknShBupnAXiK6b67MD1qLwtOF5RGMI22xV+QYw=
Message-ID: <6bc632150804290216j434e51fel255e7f76b0a50b0b@mail.gmail.com>
Date: Tue, 29 Apr 2008 14:46:18 +0530
From: "pradeep singh rautela" <rautelap@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Q]Can a file be dual licensed in upstream kernel?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080429095015.2e05f470@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6bc632150804282237o1aa04e28t93f46874cd14721f@mail.gmail.com>
	 <20080429095015.2e05f470@core>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 2:20 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Tue, 29 Apr 2008 11:07:37 +0530
>
> "pradeep singh rautela" <rautelap@gmail.com> wrote:
>
>
> > Hi All,
>  >
>  > A small query.
>  > Can a module/file be Dual licensed(i.e BSD/GPLv2) in the upstream
>  > Linux kernel sources?
>
>  The copy you submit to the kernel needs to be GPL. How you choose to
>  licence it in addition is your business (assuming it is all your own
>  work). Various drivers in the kernel (eg much of infiniband and ACPI) are
>  issued by their authors with multiple licences for different projects.

Thank you for kind explanation, Alan.
That helped a lot.

Regards,
   --Pradeep
>
>  Alan
>



-- 
Pradeep Singh Rautela
http://eagain.wordpress.com
http://emptydomain.googlepages.com
