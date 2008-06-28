Return-Path: <linux-kernel-owner+w=401wt.eu-S1753332AbYF1FPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbYF1FPE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 01:15:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYF1FOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 01:14:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43263 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbYF1FOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 01:14:53 -0400
Message-ID: <4865C7A0.6040102@zytor.com>
Date: Fri, 27 Jun 2008 22:09:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Glauber Costa <gcosta@redhat.com>
CC: "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, x86@kernel.org
Subject: Re: [PATCH 08/39] don't use word-size specifiers
References: <1214602486-17080-1-git-send-email-gcosta@redhat.com> <1214602486-17080-2-git-send-email-gcosta@redhat.com> <1214602486-17080-3-git-send-email-gcosta@redhat.com> <1214602486-17080-4-git-send-email-gcosta@redhat.com> <1214602486-17080-5-git-send-email-gcosta@redhat.com> <1214602486-17080-6-git-send-email-gcosta@redhat.com> <1214602486-17080-7-git-send-email-gcosta@redhat.com> <1214602486-17080-8-git-send-email-gcosta@redhat.com> <1214602486-17080-9-git-send-email-gcosta@redhat.com> <48657524.4020307@kernel.org> <48657636.8070208@kernel.org> <486596BE.8090407@redhat.com>
In-Reply-To: <486596BE.8090407@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> They're all about unification, but I split it for bisectability, as ingo 
> many times requested (and it happened for me to agree completely with it
> after a while ;-)).
> 
> So, exactly because not using size specifiers can introduce bugs here, I 
> did it in a separate patch. But it all end at unification in the end.
> 
> Sorry if the intention was not explicit enough.

No problem, I just wanted to verify.  Thank you :)

	-hpa
