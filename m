Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbYJCXp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbYJCXp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 19:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbYJCXpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 19:45:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:62871 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbYJCXpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 19:45:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=TLJ2EO1uPRdMM9xechX5D58VXyKNP9gWFpB13aiNoGqGV5bRqCbzzhulgydK2DTEWK
         sTbRMaI8Te0QrkiJGdJr3vNFdq3ru3D7KRxVJScbVO3xpdPRiKEiczOhvA6yGDYmNAr+
         xhOrJIfCltOkcNO+xwlJuhkuKihPs6Rni1sxk=
Message-ID: <86802c440810031645m5a09c243se072cbcc6f2a151d@mail.gmail.com>
Date: Fri, 3 Oct 2008 16:45:16 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Zachary Amsden" <zach@vmware.com>
Subject: Re: kexec with vmware esx 3.0.2
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Vivek Goyal" <vgoyal@redhat.com>, "Alok Kataria" <akataria@vmware.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>
In-Reply-To: <1223074735.7330.138.camel@bodhitayantram.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440810031408i60e2036ax805bfd997092cd86@mail.gmail.com>
	 <1223068893.7330.117.camel@bodhitayantram.eng.vmware.com>
	 <86802c440810031440o59359f30ka72230b4b0ff73e@mail.gmail.com>
	 <1223070521.7330.122.camel@bodhitayantram.eng.vmware.com>
	 <86802c440810031458s1ce79589s2448aa0869a74e21@mail.gmail.com>
	 <1223071731.7330.127.camel@bodhitayantram.eng.vmware.com>
	 <86802c440810031551g246232c9n520ef43c6881b8af@mail.gmail.com>
	 <1223074735.7330.138.camel@bodhitayantram.eng.vmware.com>
X-Google-Sender-Auth: 14a607d4e72947a1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 3, 2008 at 3:58 PM, Zachary Amsden <zach@vmware.com> wrote:
> On Fri, 2008-10-03 at 15:51 -0700, Yinghai Lu wrote:
>
>> ok, my question is: anyone tried to use kexec with vmware?
>
> Do you mean has anyone tried to use kexec in Linux running under VMware,

that should work

> or do you mean has anyone tried to use kexec to start ESX?

yeah, that is strange request. hope it work..

YH
