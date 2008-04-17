Return-Path: <linux-kernel-owner+w=401wt.eu-S1760532AbYDQIef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760532AbYDQIef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 04:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYDQIe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 04:34:27 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:21633 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbYDQIe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 04:34:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=FhavUSPlJawFYuN4138fXITc1V+7nsAl3Y3rXgxeNYOdvrmlgzUDfHO+3KHO9Qe0YGU548qEBgLKWbqxOhKjNnqD8biltI0i8mk8ymwqwF4bcSayRG35VPlQ4b6eQHtWIujC2yY7EbVlcZZVP36Hri1dPJq8WLU2iARAF0dnngo=
Message-ID: <84144f020804170134k4c98f022xc247442592fb1a44@mail.gmail.com>
Date: Thu, 17 Apr 2008 11:34:25 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0804171130090.4929@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080416202338.GA6007@elte.hu>
	 <20080417002552.5742ad65.akpm@linux-foundation.org>
	 <84144f020804170045s24cbb802u3358ec6b5d391a10@mail.gmail.com>
	 <20080417012051.ed56f4ab.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0804171130090.4929@sbz-30.cs.Helsinki.FI>
X-Google-Sender-Auth: 6a822c159c6750a2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 11:32 AM, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
>  Oh sorry, I guess I fixed up problems I spot myself. There indeed seem to
>  be some comments by Andrew that have not been addressed:

s/have not/might have not/

>   http://lkml.org/lkml/2008/2/23/68
