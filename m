Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbZFJRdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbZFJRdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 13:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbZFJRc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 13:32:59 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:54672 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbZFJRc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 13:32:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RRkPfKQLwu0M0lZ1ZSvtJCXt2gmaz4gVHSWasPXonuhLbmQUsWjXkX6CtJsL2VPctt
         M/Q/PMxDDHeo5XxzTBIAKrjNOqYE5uHAz34PxVVyiuXgy2LOSSKK3bu8oHNFH7EFlLu8
         m9JjHBu85cvoEPJI98OvoQPlli98Vn/FU6oFU=
MIME-Version: 1.0
In-Reply-To: <1244626509.5847.399.camel@localhost.localdomain>
References: <1244550775.5847.385.camel@localhost.localdomain>
	 <f5be75d5abc1acd236bedf36c55a860e@localhost>
	 <1244626509.5847.399.camel@localhost.localdomain>
Date: Wed, 10 Jun 2009 10:27:00 -0700
Message-ID: <a95a62fe0906101027y503e49c5r78813b6b802a06b@mail.gmail.com>
Subject: Re: [PATCHv2] MTD: Add UBI reboot notifier
From: Kevin Cernekee <kpc.mtd@gmail.com>
To: dedekind@infradead.org
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 2:35 AM, Artem Bityutskiy<dedekind@infradead.org> wrote:
> I've pushed this patch to ubi-2.6.git/master. I've tested it
> even. And I amended comments a little. Please, check it:
>
> http://git.infradead.org/ubi-2.6.git?a=commit;h=79c293b2629882a1db3a850ed6b84bd1d8a464a7
>
> If you are fine with this, I'll put it to ubi-2.6.git/linux-next
> and merge it this merge window.

Looks good to me.  Thanks.
