Return-Path: <linux-kernel-owner+w=401wt.eu-S968477AbXG3Uhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968477AbXG3Uhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 16:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967226AbXG3Uh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 16:37:28 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:1082 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967136AbXG3Uh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 16:37:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=swUUxAKTtlXes2TQ63DKWHWmlvBDYahT+CL/fd0TNPsRhelb30E2IYjAz2dg6mz2eUu/pOaKgEAtcr4YQ0Y6sWu9KwiVI2SNxv0NP+qAky8P5bb0zNmv47S1dXhcOBtlVaC0LoLXQ3QyR0HY7RbqV4aUItUqmyv5/XT4ckKwnWg=
Message-ID: <3aa654a40707301337w52bbe246o99db15b9f8e7a2c4@mail.gmail.com>
Date: Mon, 30 Jul 2007 13:37:26 -0700
From: "Avuton Olrich" <avuton@gmail.com>
To: "Sasa Ostrouska" <casaxa@gmail.com>
Subject: Re: forcedeth ?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <dcf706c60707301301j21d3cf60n59a686c9abb5e5b3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dcf706c60707301301j21d3cf60n59a686c9abb5e5b3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/30/07, Sasa Ostrouska <casaxa@gmail.com> wrote:
> Hi people,
>
> I'm using this on a x86-64 amd machine. During boot of the last
> 2.6.22.1 kernel I get this error:

Somewhat unrelated, but I had a similar forcedeth problem, I took the
latest git forcedeth.c and put it into 2.6.22.1 and it worked for me.

Good luck!
-- 
avuton
--
 Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
