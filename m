Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbZCJOKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbZCJOKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 10:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZCJOKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 10:10:31 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:38619 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbZCJOKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 10:10:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VAtfDCN/m+Sahd/RmqH/PeelpbjEDYfoU2mIOxONtYLIcZ9HBCDQHEuRowaKwuyfXC
         96LWHjHGb6PLh700PvfJA8CiwxHBbF30DzhqE1cwOGphCRz7IVCMPt6+4524WlB0tm75
         fBJUcZe+iV3UWjBJyDwtaI92ryfGT2gwhpfXk=
Date: Tue, 10 Mar 2009 22:10:56 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Stuart Xu <sxu@soleranetworks.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Kernel tree with KGDB patched
Message-ID: <20090310141056.GC3157@hack>
References: <395C6DBC66158B4CA921D1A81BB7BE7CD03C8E42@EXVMBX015-1.exch015.msoutlookonline.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <395C6DBC66158B4CA921D1A81BB7BE7CD03C8E42@EXVMBX015-1.exch015.msoutlookonline.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 12:00:12PM -0700, Stuart Xu wrote:
>Hi,
>
>From online discussions, it seems that the linux 2.6 tree has included KGDB.  Anyone can tell me where and how to get such a kernel tree (preferably 2.6.27 ) that with KGDB patched already?
>

Isn't kgdb already in the mainline?

I saw drivers/serial/kgdboc.c and arch/x86/kernel/kgdb.c. Am I wrong? :)


-- 
Do what you love, f**k the rest! F**k the regulations!
 
