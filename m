Return-Path: <linux-kernel-owner+w=401wt.eu-S1757704AbYCaSwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704AbYCaSwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 14:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbYCaSv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 14:51:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:26243 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbYCaSvz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 14:51:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=MuJNkbqT66kit5JDnuza0hzTBuUjlreqqxG4J8BjR6KzGkRDB2tLbViO+iSwvCLI1ngcSJCDxsvFTZ257YfwZpMxnpubB6syfdILJI44wtgzHm15qX3/QcIW7mpKtUfK6SWuETHrYhyEe37Vd3IPO33pXPoOnAXdR7iNCqDdRFM=
Message-ID: <517f3f820803311151nb62066ay109b6e27f5df156@mail.gmail.com>
Date: Mon, 31 Mar 2008 20:51:52 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Samuel Thibault" <samuel.thibault@ens-lyon.org>,
       "Michael Kerrisk" <mtk.manpages@gmail.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH,TRIVIAL] AF_UNIX, accept() and addrlen
In-Reply-To: <20080331094440.GA4406@implementation>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080308022321.GC5853@implementation>
	 <20080323.215641.192753003.davem@davemloft.net>
	 <20080324104330.GF4434@implementation.uk.xensource.com>
	 <87abko734d.fsf@basil.nowhere.org>
	 <20080324121719.GJ4434@implementation.uk.xensource.com>
	 <20080324122700.GK4434@implementation.uk.xensource.com>
	 <517f3f820803302100sdd50d71m4a990993f45e746c@mail.gmail.com>
	 <20080331094440.GA4406@implementation>
X-Google-Sender-Auth: 50223a553bbd8b89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/31/08, Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:
> Michael Kerrisk, le Mon 31 Mar 2008 06:00:50 +0200, a écrit :
>
> > My understanding about abstract namespace sockets (what Samuel calls
>  > unnamed sockets)
>
>
> No, unnamed sockets are not in the abstract namespace sockets.  They
>  really have _no_ name.

Ahhh -- sorry -- I didn't read the thread closely enough...
