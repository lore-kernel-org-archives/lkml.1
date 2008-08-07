Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbYHGVYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbYHGVYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 17:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756896AbYHGVYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 17:24:00 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:51694 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799AbYHGVX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 17:23:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dsZ+c1Qb5ufOW+WBqfJLlUKloUN9MW0x4XHfNC3NaR2wmFKy/tlad5qq4qEMdH9HRH
         cL4Myo8tZL5sZv1TLS4IBVWkPRqNzYEV7qGHugrhfKaA2UJB5FQXxhPKSb3aIaiGfE5V
         vcE6BFea93K4Dr0qsvn87j8mK/dWauUeNwLfM=
Date: Fri, 8 Aug 2008 01:23:54 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: J?rgen Scholz <juergen@kernkraft400.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: XFS kernel crash
Message-ID: <20080807212354.GA10313@martell.zuzino.mipt.ru>
References: <9CFBEED5-C880-4EC3-A748-D5AED4E8A470@kernkraft400.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9CFBEED5-C880-4EC3-A748-D5AED4E8A470@kernkraft400.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 12:44:02PM +0200, J?rgen Scholz wrote:
> I hope I'm turning to the right mailing list with this problem. To me it 
> looks like a problem in the XFS filesystem and I consider defects in 
> filesystem very, very critical.

Vendor kernel, VMware, DRBD, something called vmhgfs.

It could be anything.

linux-kernel is simply wrong place to ask.

