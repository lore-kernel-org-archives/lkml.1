Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbXKWA13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbXKWA13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 19:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbXKWA1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 19:27:21 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:40562 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbXKWA1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 19:27:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UH3V5POitVpZF45IfOPYDUH67O5RG9Dkel2o3IWO0z/oaJ7/bx4LIi3KLOOWjPGTNILQXXO9C5881RUOqyOymoQg/nZlWF0L6kq2RjvSoZEv+M5hUJDi+IH4MQh0dF9x8O61VErOWguoIiflqPEjC/Cj0el+IJrxdXGrKtbyxVE=
Message-ID: <3aa654a40711221627w4ddf36eel54fdac66f81cac4e@mail.gmail.com>
Date: Thu, 22 Nov 2007 16:27:19 -0800
From: "Avuton Olrich" <avuton@gmail.com>
To: "Daniel Drake" <dsd@gentoo.org>
Subject: Re: [RFC] Documentation about unaligned memory access
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, kune@deine-taler.de,
       johannes@sipsolutions.net
In-Reply-To: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 22, 2007 4:15 PM, Daniel Drake <dsd@gentoo.org> wrote:
> Before I do so, any comments on the following?
>

< above case it would insert 2 bytes of padding inbetween field1 and field2.
> above case it would insert 2 bytes of padding in between field1 and field2.


< moving field3 to sit inbetween field1 and field2 (where the padding is
> moving field3 to sit in between field1 and field2 (where the padding is
-- 
avuton
--
 Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
