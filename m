Return-Path: <linux-kernel-owner+w=401wt.eu-S1161021AbXDCPlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161021AbXDCPlo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 11:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161023AbXDCPln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 11:41:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:37515 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161021AbXDCPlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 11:41:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Tzo2dOqA0jLkiG3Sh48ThlVSgIsu7KGcs+cggYrJtN83T5XbicTOT6W3bpAzlElw4xJLlfBPpR971RXSmjoDhByIPzvpxW5S4zjX4P3mNGUqFPvf5kmBElMIkBDWU7Q6Z5ZQ7JCRrbkwl2nSHUpnaMkocUKJnhg3MhT7mGEhOTo=
Message-ID: <75b66ecd0704030841r3783412doe27f3656169d7030@mail.gmail.com>
Date: Tue, 3 Apr 2007 11:41:35 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Christian Kujau" <christian@g-house.de>
Subject: Re: 2.6.20.4: NETDEV WATCHDOG and lockups
Cc: "Robert Hancock" <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Len Brown" <lenb@kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704031620510.3963@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.P3upyx4QAcXHtp/c/s+b4/cKk5w@ifi.uio.no>
	 <fa.u/RjoL2ybMMaAY+GDfTzm7jO5d0@ifi.uio.no>
	 <fa.G7qJfhdvOynxlffny+Xc1kIaqBY@ifi.uio.no> <4612648D.4090904@shaw.ca>
	 <Pine.LNX.4.64.0704031620510.3963@sheep.housecafe.de>
X-Google-Sender-Auth: aadace8a745156ce
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/3/07, Christian Kujau <christian@g-house.de> wrote:
> On Tue, 3 Apr 2007, Robert Hancock wrote:
> > Although it's not as bad with servers, many machines are designed to run only
> > Windows (which normally always uses ACPI) and simply aren't tested well or at
> > all with ACPI disabled so you can run into a lot of problems which are just
> > bugs in the BIOS, etc.
>
> I only thought it was the other way around: less (active, used) code -
> less bug (caused by strange ACPI implementations). But I can see your
> point.
>

We have a bunch of servers here where Linux will only see one core per
processor unless ACPI is enabled.

Lee
